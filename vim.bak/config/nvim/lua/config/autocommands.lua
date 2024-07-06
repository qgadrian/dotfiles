-- FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "qf", "lspinfo" },
    command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
  }
)

-- Silent write, file load, lines delete
vim.api.nvim_create_autocmd(
  "BufWritePre",
  {
    pattern = "*",
    command = [[silent! w]]
  }
)

vim.api.nvim_create_autocmd(
  "BufRead",
  {
    pattern = "*",
    command = [[noautocmd silent!]]
  }
)

-- vim.api.nvim_exec([[
--   autocmd! BufWritePre * silent! write
--   autocmd! BufRead * noautocmd silent!
-- ]], false)

-- vim.g.qf_loclist_window_bottom = 0
