vim.g.EasyMotion_smartcase = 1
vim.g.EasyMotion_use_smartsign_us = 1

vim.api.nvim_set_keymap('n', '<leader>em', '<Plug>(easymotion-sn)', {
  noremap = false,
  silent = false
})
