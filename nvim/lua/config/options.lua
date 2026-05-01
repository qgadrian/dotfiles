-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local vim = vim
local opt = vim.opt

vim.g.markdown_fenced_languages = {
  "html",
  "javascript",
  "typescript",
  "css",
  "scss",
  "lua",
  "vim",
  "sh",
}

vim.diagnostic.config({
  float = { border = "rounded" }, -- add border to diagnostic popups
})

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

-- Sync nvim tab name with Claude Code session name (set via /rename in Claude).
-- Manual <leader>tr always wins; <leader>tR clears the override and reveals
-- the synced name. Disable with :lua vim.g.claude_sync_tab_names = false
vim.g.claude_sync_tab_names = true
