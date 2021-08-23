"
" Auto-format * files prior to saving them
" See: https://neovim.io/doc/user/lsp.html#lsp-faq
"
autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)
