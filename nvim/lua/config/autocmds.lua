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
    -- Don't show line numbers in terminal windows
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

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

-- Subset of peon-ping title suffixes that actually need user interaction.
-- `done`/`error`/`working` are status, not a prompt — they don't trigger [*].
local _attention_suffixes = { ": needs approval", ": question" }
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

local function read_claude_session_name(path)
  local fd = io.open(path, "r")
  if not fd then return nil end
  local content = fd:read("*a")
  fd:close()
  if not content or content == "" then return nil end
  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then return nil end
  local name = decoded.name
  if type(name) ~= "string" then return nil end
  name = vim.trim(name)
  if name == "" then return nil end
  if #name > _max_session_len then name = name:sub(1, _max_session_len) end
  return name
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

    local needs_attention = false
    local session_name = nil

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" then
        local ok_pid, shell_pid = pcall(vim.fn.jobpid, vim.bo[buf].channel)
        if ok_pid and shell_pid then
          -- Attention from peon-ping title (only matches when peon-ping is active).
          local ok_t, title = pcall(vim.api.nvim_buf_get_var, buf, "term_title")
          if ok_t and type(title) == "string" and title:sub(1, 3) == "●" then
            for _, suffix in ipairs(_attention_suffixes) do
              if title:sub(-#suffix) == suffix then
                needs_attention = true
                break
              end
            end
          end
          -- Session name from Claude's own state file (independent of peon-ping).
          if sync_enabled and session_name == nil then
            local sf = find_claude_session_file(shell_pid)
            if sf then session_name = read_claude_session_name(sf) end
          end
        end
      end
    end

    local had = pcall(vim.api.nvim_tabpage_get_var, tab, "peon_attention")
    if needs_attention ~= had then
      changed = true
      if needs_attention then
        vim.api.nvim_tabpage_set_var(tab, "peon_attention", "1")
      else
        pcall(vim.api.nvim_tabpage_del_var, tab, "peon_attention")
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
