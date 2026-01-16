-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- To quickly jump to next/previous match
vim.keymap.set("n", "*", "*``", { noremap = true, silent = false })

-- Terminal shortcuts
-- noremap <leader>term :let $VIM_DIR=expand('%:p:h')<CR>:term!<CR>
vim.keymap.set("n", "<leader>term", ":let $VIM_DIR=expand('%:p:h')<CR>:term<CR>")
vim.keymap.set("n", "<leader>tb", ":new<CR>:let $VIM_DIR=expand('FindRootDirectory()')<CR>:terminal<CR>")
vim.keymap.set("n", "<leader>tvb", ":vnew<CR>:let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>")

-- Increase window size
vim.keymap.set("n", "<C-S-9>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-S-0>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Support nested vim's sessions
-- tnoremap <Esc> <C-\><C-n>
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
-- tnoremap <C-v><Esc> <Esc>
vim.keymap.set("t", "<C-v><Esc>", "<Esc>", { noremap = true })
-- tnoremap <C-[> <Esc>
vim.keymap.set("t", "<C-[>", "<Esc>", { noremap = true })

-- Highlight current word without moving
vim.keymap.set("n", "<leader>hw", ":let @/='\\<<C-R>=expand(\"<cword>\")<CR>\\>'<CR>:set hls<CR>", { noremap = true })

-- Reload current buffer file from disk
vim.keymap.set("n", "<leader>rf", "<cmd>e!<cr>", { noremap = true })

-- Delete hidden buffers
-- vim.keymap.set("n", "<leader>bD", Snacks.bufdelete, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Copy file path to clipboard
vim.keymap.set("n", "<leader>ccp", "<cmd>let @+=expand('%')<cr>", { noremap = true })

-- Avoid blowup (does not happen anymore, kept for reference)
-- vim.keymap.set("n", "<C-z>", "<NOP>", { noremap = true })

-- Avoid annoyances when wanted to save
-- vim.keymap.set("n", ":W", ":w", { noremap = true })
-- vim.keymap.set("n", "<leader>a", "<Nop>", { noremap = true })

-- Easy & quick word yank to clipboard (lazyvim uses clipboard always, kept for reference in case I disable it)
-- nnoremap <leader>yw "*yiw

-- Move windows with arrow keys
vim.keymap.set("n", "<C-S-Up>", "<C-w>k")
vim.keymap.set("n", "<C-S-Down>", "<C-w>j")
vim.keymap.set("n", "<C-S-Left>", "<C-w>h")
vim.keymap.set("n", "<C-S-Right>", "<C-w>l")

-- Create new windows
vim.keymap.set("n", "<leader>hb", "<cmd>new<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>vb", "<cmd>vnew<cr>", { noremap = true, silent = true })

-- Create new tab shortcut
vim.keymap.set("n", "<leader>te", "<cmd>tabnew<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<cr>:terminal<cr>", { noremap = true, silent = true })

-- Move tabs with arrow keys
-- noremap <M-S-Left> gT
vim.keymap.set("n", "<M-S-Left>", "<cmd>tabprevious<cr>")
-- noremap <M-S-Right> gt
vim.keymap.set("n", "<M-S-Right>", "<cmd>tabnext<cr>")
-- nnoremap <silent> <M-h> :tabprevious<CR>
-- vim.keymap.set("n", "<M-h>", ":tabprevious<CR>", { noremap = true, silent = true })
-- nnoremap <silent> <M-l> :tabnext<CR>
-- vim.keymap.set("n", "<M-l>", "<cmd>tabnext<cr>", { noremap = true, silent = true })

-- Reorganize tabs
-- noremap <silent> <C-M-Left> :tabm -1<CR>
vim.keymap.set("n", "<C-M-Left>", "<cmd>tabmove -1<CR>", { noremap = true, silent = true })
-- noremap <silent> <C-M-Right> :tabm +1<CR>
vim.keymap.set("n", "<C-M-Right>", "<cmd>tabmove +1<CR>", { noremap = true, silent = true })

-- Telescope shortcuts
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", {})

-- LSP
-- see diagnostics
vim.keymap.set("n", "<C-s>", "<cmd>lua vim.diagnostic.open_float()<CR>")
-- format shortcut
vim.keymap.set("n", "F", "<cmd>lua vim.lsp.buf.format()<CR>")
-- go to definition in split window
vim.keymap.set("n", "gv", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { desc = "Go to definition in vertical split" })

-- Word replace
vim.keymap.set("n", "<leader>rr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gc<Left><Left><Left>")

-- create new lines without entering in insert mode
vim.keymap.set("n", "o", "o<esc>")
vim.keymap.set("n", "O", "O<esc>")

-- special characters mapping
vim.keymap.set("i", "<M-n>", "ñ", { noremap = true, silent = true })
vim.keymap.set("i", "<M-N>", "Ñ", { noremap = true, silent = true })
vim.keymap.set("i", "<M-c>", "ç", { noremap = true, silent = true })
vim.keymap.set("i", "<M-C>", "Ç", { noremap = true, silent = true })
vim.keymap.set("i", "<M-l>", "ł", { noremap = true, silent = true })
vim.keymap.set("i", "<M-L>", "Ł", { noremap = true, silent = true })
vim.keymap.set("i", "<M-a>", "á", { noremap = true, silent = true })
vim.keymap.set("i", "<M-A>", "Á", { noremap = true, silent = true })
vim.keymap.set("i", "<M-e>", "é", { noremap = true, silent = true })
vim.keymap.set("i", "<M-E>", "É", { noremap = true, silent = true })
vim.keymap.set("i", "<M-i>", "í", { noremap = true, silent = true })
vim.keymap.set("i", "<M-I>", "Í", { noremap = true, silent = true })
vim.keymap.set("i", "<M-o>", "ó", { noremap = true, silent = true })
vim.keymap.set("i", "<M-O>", "Ó", { noremap = true, silent = true })
vim.keymap.set("i", "<M-u>", "ú", { noremap = true, silent = true })
vim.keymap.set("i", "<M-U>", "Ú", { noremap = true, silent = true })
vim.keymap.set("i", "<M-w>", "ü", { noremap = true, silent = true })
vim.keymap.set("i", "<M-W>", "Ü", { noremap = true, silent = true })
vim.keymap.set("i", "<S-M-/>", "¿", { noremap = true, silent = true })
vim.keymap.set("i", "<S-M-1>", "¡", { noremap = true, silent = true })

-- Duplicate a line and comment out the first line
vim.keymap.set("n", "<C-c>", "ciw")

-- Move selected lines with shift+j or shift+k
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
