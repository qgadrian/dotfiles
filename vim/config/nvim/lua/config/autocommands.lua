-- FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

vim.api.nvim_create_autocmd(
    "FileType",
    {
      pattern = { "qf", "lspinfo" },
      command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
    }
)

-- vim.g.qf_loclist_window_bottom = 0
