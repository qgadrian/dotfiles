require('telescope').setup {
  defaults = {
    prompt_prefix = '🔍 ',
    color_devicons = true,
    file_ignore_patterns = {".git", "deps", "node_modules"}
  },
  pickers = {
    find_files = {
      hidden = true,
      files = true
    },
    file_browser = {
      hidden = true,
      files = true
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>Telescope resume<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>ca', "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", {})

-- TODO
-- Remove `vim/config/vim/telescope.vim`
-- See https://github.com/neovim/neovim/pull/16591
--
-- vim.keymap.set('n', '<leader>ca', function()
--   require('telescope.builtin').lsp_code_actions()
-- end, { expr = true })
