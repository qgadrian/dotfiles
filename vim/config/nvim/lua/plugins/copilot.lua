-- update the copilot maps for next suggestion
vim.api.nvim_set_keymap('i', '<C-;>', '<Plug>(copilot-next)', { noremap = false })
vim.api.nvim_set_keymap('i', '<C-,>', '<Plug>(copilot-previous)', { noremap = false })
vim.api.nvim_set_keymap('i', '<C-x>', '<Plug>(copilot-cancel)', { noremap = false })
-- accept copilot suggestion
vim.api.nvim_set_keymap('i', '<C-g>', '<Plug>(copilot-accept)', { noremap = false })
