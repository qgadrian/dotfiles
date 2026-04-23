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

local _attention_suffixes = { ": done", ": needs approval", ": question", ": error" }

local function scan_claude_attention()
  local changed = false
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local needs_attention = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" then
        local alive = pcall(vim.fn.jobpid, vim.bo[buf].channel)
        if alive then
          local ok, title = pcall(vim.api.nvim_buf_get_var, buf, "term_title")
          if ok and type(title) == "string" and title:sub(1, 3) == "●" then
            for _, suffix in ipairs(_attention_suffixes) do
              if title:sub(-#suffix) == suffix then
                needs_attention = true
                break
              end
            end
          end
        end
      end
      if needs_attention then break end
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
_G._claude_attention_timer:start(2000, 2000, vim.schedule_wrap(scan_claude_attention))
