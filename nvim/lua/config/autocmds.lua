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
