-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Delete git buffer when hidden
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("gitcommit"),
  pattern = "gitcommit",
  callback = function()
    vim.opt.bufhidden = "delete"
  end,
})

-- Auto insert mode after closing a gitcommit buffer
vim.api.nvim_create_autocmd("BufDelete", {
  group = augroup("delete_gitcommit"),
  pattern = { "gitcommit", "COMMIT_EDITMSG" },
  desc = "Start insert mode after closing gitcommit buffer",
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Automatically equalize splits when Vim is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
  group = augroup("resize"),
  pattern = "*",
})

-- Terminal autocmds
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  pattern = "*",
  desc = "Start terminal in insert mode",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false
    -- Clear all gutter columns so the terminal renders flush at column 1.
    -- Without this, residual signcolumn/foldcolumn shifts the prompt right
    -- on terminals opened immediately after :tabnew / :new / :vnew.
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"

    -- Automatically go to insert mode on terminal windows
    vim.cmd("startinsert")
  end,
})

-- Enable quick exit on certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("easy_quit"),
  pattern = {
    "help",
    "man",
    "lspinfo",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { buffer = true, silent = true })
  end,
})

-- Check for spelling in text filetypes and enable wrapping
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("set_wrap"),
  pattern = {
    "gitcommit",
    "markdown",
    "text",
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

-- Silent write, file load, lines delete
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("silent_write"),
  pattern = "*",
  command = [[silent! w]],
})

vim.api.nvim_create_autocmd("BufRead", {
  group = augroup("silent_read"),
  pattern = "*",
  command = [[noautocmd silent!]],
})

-- Claude Code tab status. Sources, all written by Claude Code or its hooks:
--   ~/.claude/sessions/<pid>.json   per-process session: status (busy/idle),
--                                   kind (interactive/bg), jobId, parkedJobId
--   ~/.claude/jobs/<jobId>/state.json  background job: state (working/
--                                   blocked/done/stopped), inFlight.tasks
--   ~/.claude/attention/<pid>/      written by .claude/hooks/claude_attention.py:
--                                   flag ("needs_input <origin>") and
--                                   agents/<id> (running subagents)
--   ~/.claude/daemon/roster.json    which session launched each background
--                                   worker (handoff continuation chains)
--   terminal title (b:term_title)   "<spinner> <session name>": a client
--                                   attached to a background session via the
--                                   fleet view shows that session, so the
--                                   title wins over the client's own file
-- Resulting states, highest tab priority first (several Claude terminals in
-- one tab show the most important one):
--   needs_input  a permission prompt / question is waiting on you      ❓
--   error        last turn errored                                     ❌
--   background   main loop idle, but subagents, background tasks or a
--                a launched continuation session are still running      🔧
--   working      main loop running                                     🟢
--   idle         your turn, nothing running                            ⏰
-- :ClaudeTabDebug shows how each tab's state was derived.
local _status_map = {
  -- session.json status → normalized status
  busy        = "working",
  working     = "working",
  in_progress = "working",
  idle        = "idle",
  done        = "idle",
  completed   = "idle",
  error       = "error",
}
local _priority = { needs_input = 5, error = 4, background = 3, working = 2, idle = 1 }
local _max_session_len = 64
local _claude_dir = vim.fn.expand("~/.claude")
local _sessions_dir = _claude_dir .. "/sessions"
local _attention_dir = _claude_dir .. "/attention"
local _jobs_dir = _claude_dir .. "/jobs"
local _agent_marker_ttl = 6 * 3600 -- ignore subagent markers older than this

-- Walk descendant pids of `root_pid`, return the path of the first
-- ~/.claude/sessions/<pid>.json file found, or nil. Bounded for safety.
-- Only successful lookups are cached; negative results re-probe every poll
-- so a Claude that starts after the first scan still gets picked up.
local _claude_pid_cache = {}  -- [shell_pid] = claude_pid
local function find_claude_session_file(root_pid)
  if not root_pid or root_pid <= 0 then return nil end
  local cached = _claude_pid_cache[root_pid]
  if cached then
    local f = _sessions_dir .. "/" .. cached .. ".json"
    if vim.fn.filereadable(f) == 1 then return f end
    _claude_pid_cache[root_pid] = nil
  end
  local stack = { root_pid }
  local seen = {}
  for _ = 1, 64 do
    local pid = table.remove(stack)
    if pid == nil then break end
    if not seen[pid] then
      seen[pid] = true
      local f = _sessions_dir .. "/" .. pid .. ".json"
      if vim.fn.filereadable(f) == 1 then
        _claude_pid_cache[root_pid] = pid
        return f
      end
      local children = vim.fn.systemlist({ "pgrep", "-P", tostring(pid) })
      if vim.v.shell_error == 0 then
        for _, c in ipairs(children) do
          local n = tonumber(c)
          if n then table.insert(stack, n) end
        end
      end
    end
  end
  return nil
end

-- JSON reads are cached by (mtime, size) so the 2s poll only re-decodes files
-- that changed. JSON nulls decode to nil.
local _json_cache = {} -- [path] = { key = "...", value = table }
local function read_json(path)
  local st = vim.uv.fs_stat(path)
  if not st then
    _json_cache[path] = nil
    return nil
  end
  local key = st.mtime.sec .. ":" .. st.mtime.nsec .. ":" .. st.size
  local cached = _json_cache[path]
  if cached and cached.key == key then return cached.value end
  local value = nil
  local fd = io.open(path, "r")
  if fd then
    local content = fd:read("*a")
    fd:close()
    if content and content ~= "" then
      local ok, decoded = pcall(vim.json.decode, content, { luanil = { object = true, array = true } })
      if ok and type(decoded) == "table" then value = decoded end
    end
  end
  _json_cache[path] = { key = key, value = value }
  return value
end

local function read_attention_flag(pid)
  local fd = io.open(_attention_dir .. "/" .. pid .. "/flag", "r")
  if not fd then return nil end
  local content = fd:read("*a") or ""
  fd:close()
  local word, origin = content:match("^(%S+)%s+(%S+)")
  if word == "needs_input" then return origin end
  return nil
end

local function count_active_agents(pid)
  local dir = _attention_dir .. "/" .. pid .. "/agents"
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return 0 end
  local now, n = os.time(), 0
  while true do
    local name = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local st = vim.uv.fs_stat(dir .. "/" .. name)
    if st and now - st.mtime.sec < _agent_marker_ttl then n = n + 1 end
  end
  return n
end

local function read_job(job_id)
  if type(job_id) ~= "string" or not job_id:match("^[%w_-]+$") then return nil end
  return read_json(_jobs_dir .. "/" .. job_id .. "/state.json")
end

-- All live session JSONs, listed at most once per scan (reset by the scanner).
local _scan_sessions = nil
local function live_sessions()
  if _scan_sessions then return _scan_sessions end
  local list = {}
  local handle = vim.uv.fs_scandir(_sessions_dir)
  while handle do
    local name = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if name:match("^%d+%.json$") then
      local d = read_json(_sessions_dir .. "/" .. name)
      if d and type(d.pid) == "number" then list[#list + 1] = d end
    end
  end
  _scan_sessions = list
  return list
end

-- State of one Claude process from its own session JSON, flag, markers and job.
local function session_activity(d, why)
  if read_attention_flag(d.pid) then
    why[#why + 1] = "flag needs_input (pid " .. d.pid .. ")"
    return "needs_input"
  end
  local status = type(d.status) == "string" and _status_map[d.status] or nil
  if status == "error" or status == "working" then
    why[#why + 1] = "status " .. d.status .. " (pid " .. d.pid .. ")"
    return status
  end
  local job = read_job(d.jobId)
  if job and job.state == "blocked" then
    why[#why + 1] = "job " .. d.jobId .. " blocked"
    return "needs_input"
  end
  local inflight = job and job.inFlight and tonumber(job.inFlight.tasks) or 0
  local agents = count_active_agents(d.pid)
  if inflight > 0 or agents > 0 then
    why[#why + 1] = ("pid %d idle; job tasks=%d, subagents=%d"):format(d.pid, inflight, agents)
    return "background"
  end
  if status then why[#why + 1] = "status " .. d.status .. " (pid " .. d.pid .. ")" end
  return status
end

-- Background sessions launched by a session (handoff continuations, etc.).
-- The daemon roster records, per live worker, the session ids that launched
-- it (dispatch.env.CLAUDE_CODE_LAUNCHED_BY_SESSION_IDS). Only that key is read.
local function launched_children()
  local roster = read_json(_claude_dir .. "/daemon/roster.json")
  local children = {} -- [parent session id] = { child session id, ... }
  if not roster or type(roster.workers) ~= "table" then return children end
  for _, w in pairs(roster.workers) do
    local dispatch = type(w) == "table" and w.dispatch or nil
    local env = type(dispatch) == "table" and dispatch.env or nil
    local by = type(env) == "table" and env.CLAUDE_CODE_LAUNCHED_BY_SESSION_IDS or nil
    local child = type(dispatch) == "table" and dispatch.sessionId or w.sessionId
    if type(by) == "string" and type(child) == "string" then
      for parent in by:gmatch("[^,%s]+") do
        children[parent] = children[parent] or {}
        table.insert(children[parent], child)
      end
    end
  end
  return children
end

local function session_by(field, value)
  if value == nil then return nil end
  for _, s in ipairs(live_sessions()) do
    if s[field] == value then return s end
  end
  return nil
end

-- True when any live descendant of `session_ids` (launched directly or through
-- a chain of handoffs) is working, running tasks or waiting on input.
local function active_continuation(session_ids, why)
  local children = launched_children()
  local queue, seen = {}, {}
  for _, sid in ipairs(session_ids) do queue[#queue + 1] = sid end
  while #queue > 0 and #queue < 64 do
    local sid = table.remove(queue, 1)
    if not seen[sid] then
      seen[sid] = true
      for _, child in ipairs(children[sid] or {}) do
        local s = session_by("sessionId", child)
        if s then
          local act = session_activity(s, {})
          if act == "working" or act == "background" or act == "needs_input" then
            why[#why + 1] = ("continuation %q is %s"):format(tostring(s.name), act)
            return true
          end
        end
        queue[#queue + 1] = child
      end
    end
  end
  return false
end

-- The session a terminal is showing, from its title (Claude sets it to
-- "<spinner> <session name>"). An interactive client attached to a background
-- session through the fleet view shows that session, not its own.
local function session_from_title(title)
  if type(title) ~= "string" then return nil end
  local name = vim.trim(title:gsub("^[^%w]+", ""))
  if name == "" then return nil end
  return session_by("name", name)
end

local function trim_name(name)
  if type(name) ~= "string" then return nil end
  name = vim.trim(name)
  if name == "" then return nil end
  if #name > _max_session_len then name = name:sub(1, _max_session_len) end
  return name
end

-- Returns { name, status, why, pid } for a decoded session JSON.
local function session_info(d, why)
  why = why or {}
  local status = session_activity(d, why)
  if status ~= "needs_input" and status ~= "error" and status ~= "working" then
    local ids = { d.sessionId }
    -- An interactive client whose conversation was moved to the background
    -- points at that job; the job's own process (if alive) is the real state.
    if d.parkedJobId then
      local job = read_job(d.parkedJobId)
      if job and type(job.sessionId) == "string" then ids[#ids + 1] = job.sessionId end
      local bg = session_by("jobId", d.parkedJobId)
      local parked
      if bg then
        parked = session_activity(bg, why)
      elseif job then
        why[#why + 1] = ("parked job %s %s, no live process"):format(d.parkedJobId, tostring(job.state))
        parked = job.state == "blocked" and "needs_input" or "idle"
      end
      if parked and (_priority[parked] or 0) > (_priority[status] or 0) then status = parked end
    end
    if (status == nil or status == "idle") and active_continuation(ids, why) then
      status = "background"
    end
  end
  return { name = trim_name(d.name), status = status, why = why, pid = d.pid }
end

-- State for one terminal: the Claude process found under its shell (may be
-- nil), overridden by the session its title says it is showing when that is a
-- different live session.
local function terminal_session_info(path, title)
  local own = path and read_json(path) or nil
  if own and type(own.pid) ~= "number" then own = nil end
  local shown = session_from_title(title)
  if shown and type(shown.pid) == "number" and (not own or shown.pid ~= own.pid) then
    local why = { ("title shows %q (pid %d)"):format(tostring(shown.name), shown.pid) }
    if own then why[#why + 1] = ("client %s (pid %d) ignored"):format(tostring(own.name), own.pid) end
    return session_info(shown, why)
  end
  return own and session_info(own) or nil
end

-- Last scan's per-tab detail, for :ClaudeTabDebug.
local _tab_debug = {} -- [tab handle] = { { shell_pid, file, info }, ... }

local function scan_claude_terminals()
  local changed = false
  local sync_enabled = vim.g.claude_sync_tab_names and true or false
  _scan_sessions = nil
  _tab_debug = {}

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if not sync_enabled then
      local existed = pcall(vim.api.nvim_tabpage_get_var, tab, "claude_session_name")
      if existed then
        pcall(vim.api.nvim_tabpage_del_var, tab, "claude_session_name")
        changed = true
      end
    end

    local tab_status = nil
    local tab_status_prio = 0
    local session_name = nil

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" then
        local ok_pid, shell_pid = pcall(vim.fn.jobpid, vim.bo[buf].channel)
        if ok_pid and shell_pid then
          local sf = find_claude_session_file(shell_pid)
          local entry = { shell_pid = shell_pid, file = sf }
          _tab_debug[tab] = _tab_debug[tab] or {}
          table.insert(_tab_debug[tab], entry)
          local title = vim.b[buf].term_title
          entry.title = title
          do
            local info = terminal_session_info(sf, title)
            entry.info = info
            if info then
              local prio = _priority[info.status] or 0
              if prio > tab_status_prio then
                tab_status_prio = prio
                tab_status = info.status
              end
              if sync_enabled and session_name == nil and info.name then
                session_name = info.name
              end
            end
          end
        end
      end
    end

    local ok_prev_s, prev_status = pcall(vim.api.nvim_tabpage_get_var, tab, "claude_status")
    local prev = ok_prev_s and prev_status or nil
    if tab_status ~= prev then
      changed = true
      if tab_status then
        vim.api.nvim_tabpage_set_var(tab, "claude_status", tab_status)
      else
        pcall(vim.api.nvim_tabpage_del_var, tab, "claude_status")
      end
    end

    if sync_enabled and session_name then
      local ok_prev, prev = pcall(vim.api.nvim_tabpage_get_var, tab, "claude_session_name")
      if not ok_prev or prev ~= session_name then
        vim.api.nvim_tabpage_set_var(tab, "claude_session_name", session_name)
        changed = true
      end
    end
  end
  if changed then
    vim.cmd.redrawtabline()
  end
end

if _G._claude_attention_timer then
  _G._claude_attention_timer:stop()
  _G._claude_attention_timer:close()
end
_G._claude_attention_timer = vim.uv.new_timer()

local function has_terminal_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
      return true
    end
  end
  return false
end

-- Only poll while terminals exist: the tick after the last one closes runs a
-- final scan (clearing stale tab status) and stops the timer until TermOpen.
local function claude_attention_tick()
  scan_claude_terminals()
  if not has_terminal_buffers() then
    _G._claude_attention_timer:stop()
  end
end

local function start_claude_attention_timer()
  if not _G._claude_attention_timer:is_active() then
    _G._claude_attention_timer:start(2000, 2000, vim.schedule_wrap(claude_attention_tick))
  end
end

vim.api.nvim_create_user_command("ClaudeTabDebug", function()
  scan_claude_terminals()
  local lines = {}
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local entries = _tab_debug[tab]
    if entries then
      local ok, st = pcall(vim.api.nvim_tabpage_get_var, tab, "claude_status")
      lines[#lines + 1] = ("tab %d → %s"):format(vim.api.nvim_tabpage_get_number(tab), ok and st or "none")
      for _, e in ipairs(entries) do
        local info = e.info
        lines[#lines + 1] = ("  shell %s → %s  title=%q"):format(
          e.shell_pid, e.file or "no Claude session file", tostring(e.title))
        if info then
          lines[#lines + 1] = ("    name=%s status=%s"):format(tostring(info.name), tostring(info.status))
          for _, w in ipairs(info.why) do lines[#lines + 1] = "    · " .. w end
        end
      end
    end
  end
  if #lines == 0 then lines = { "no terminal tabs" } end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Claude tabs" })
end, { desc = "Show how each tab's Claude status was derived" })

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("claude_attention"),
  callback = start_claude_attention_timer,
})

if has_terminal_buffers() then
  start_claude_attention_timer()
end

-- Janitor: stop terminal jobs explicitly on exit so their shells don't
-- outlive nvim, and expose the zsh shell-janitor as :Janitor[!]
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup("term_janitor"),
  desc = "Stop terminal jobs before exiting",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local job = vim.b[buf].terminal_job_id
      if job then
        pcall(vim.fn.jobstop, job)
      end
    end
  end,
})

vim.api.nvim_create_user_command("Janitor", function(opts)
  local cmd = "source ~/.zsh/profiles/janitor && shell-janitor" .. (opts.bang and " -k" or "")
  local out = vim.fn.system({ "zsh", "-c", cmd })
  vim.notify(out, vim.log.levels.INFO, { title = "Janitor" })
end, { bang = true, desc = "List orphaned shells (! to close them)" })
