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

-- Source of truth: ~/.claude/sessions/<pid>.json, written by Claude Code itself.
-- For kind="interactive" sessions, the relevant statuses are:
--   "busy" / "working" / "in_progress" → Claude is actively running
--   "idle"                              → Claude finished its turn (your move)
--   "done" / "completed"                → treated same as idle
--   "error"                             → last turn errored
-- We also read a sibling flag file ~/.claude/sessions/<pid>.flag written by the
-- Claude attention hook (PermissionRequest / Notification). Its contents are
-- "action_needed" or "notify" — signals that don't appear in status itself.
-- Priority (highest urgency first): action_needed > notify > error > idle > working
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
local _priority = { action_needed = 5, notify = 4, error = 3, idle = 2, working = 1 }
local _max_session_len = 64
local _sessions_dir = vim.fn.expand("~/.claude/sessions")

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

-- Read the sibling .flag file written by the attention hook. Returns one of
-- "action_needed", "notify", or nil. Anything else is treated as nil so a
-- future hook payload can't smuggle arbitrary strings into the tab name.
local function read_claude_session_flag(session_path)
  local flag_path = session_path:gsub("%.json$", ".flag")
  local fd = io.open(flag_path, "r")
  if not fd then return nil end
  local content = fd:read("*a")
  fd:close()
  if not content then return nil end
  content = vim.trim(content)
  if content == "action_needed" or content == "notify" then return content end
  return nil
end

local function read_claude_session_info(path)
  local fd = io.open(path, "r")
  if not fd then return nil end
  local content = fd:read("*a")
  fd:close()
  if not content or content == "" then return nil end
  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then return nil end
  local name = decoded.name
  if type(name) == "string" then
    name = vim.trim(name)
    if name == "" then name = nil end
    if name and #name > _max_session_len then name = name:sub(1, _max_session_len) end
  else
    name = nil
  end
  local raw = decoded.status
  local status = (type(raw) == "string") and _status_map[raw] or nil
  local flag = read_claude_session_flag(path)
  -- Flag takes precedence over status (it's a more specific signal).
  local effective = flag or status
  return { name = name, status = effective }
end

local function scan_claude_terminals()
  local changed = false
  local sync_enabled = vim.g.claude_sync_tab_names and true or false

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
          if sf then
            local info = read_claude_session_info(sf)
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
_G._claude_attention_timer:start(2000, 2000, vim.schedule_wrap(scan_claude_terminals))
