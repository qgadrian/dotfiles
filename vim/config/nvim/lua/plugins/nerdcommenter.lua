vim.api.nvim_set_keymap('n', '<leader>/', ':call nerdcommenter#Comment(1, "toggle")<CR>', {
  noremap = false,
  silent = false
})
