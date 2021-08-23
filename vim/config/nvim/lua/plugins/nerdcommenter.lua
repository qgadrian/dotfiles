vim.api.nvim_set_keymap('n', '<leader>/', ':call nerdcommenter#Comment("n", "toggle")<CR>', {
  noremap = true,
  silent = false
})
