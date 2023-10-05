-- update the copilot maps for next suggestion
vim.api.nvim_set_keymap('i', '<C-;>', '<Plug>(copilot-next)', { noremap = false })
vim.api.nvim_set_keymap('i', '<C-,>', '<Plug>(copilot-previous)', { noremap = false })
vim.api.nvim_set_keymap('i', '<C-x>', '<Plug>(copilot-dismiss)', { noremap = false })
-- accept copilot suggestion
vim.api.nvim_set_keymap('i', '<C-g>', '<Plug>(copilot-suggest)', { noremap = false })

vim.g.copilot_no_tab_map = true;
vim.g.copilot_assume_mapped = true;
vim.g.copilot_tab_fallback = "";
