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
