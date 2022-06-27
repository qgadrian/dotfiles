-- https://vimawesome.com/plugin/telescope-nvim-care-of-itself#pickers
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
    },
    live_grep = {
      -- only_sort_text = true,
    }
  },
  extensions = {
    project = {
      base_dirs = {
        {
          path = '~/workspace',
          max_depth = 2
        },
      },
      hidden_files = true,
      theme = "dropdown"
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
-- EXAMPLE: -g '*stories*' wrapHocs
vim.api.nvim_set_keymap('n', '<leader>fgg', '<cmd>Telescope live_grep<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fgr', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>Telescope resume<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fp', "<cmd>lua require('telescope').extensions.project.project{}<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>fcr', "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>ca', "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", {})

-- TODO
-- Remove `vim/config/vim/telescope.vim`
-- See https://github.com/neovim/neovim/pull/16591
--
-- vim.keymap.set('n', '<leader>ca', function()
--   require('telescope.builtin').lsp_code_actions()
-- end, { expr = true })
