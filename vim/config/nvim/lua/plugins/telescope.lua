-- https://vimawesome.com/plugin/telescope-nvim-care-of-itself#pickers
require('telescope').setup {
  defaults = {
    prompt_prefix = '🔍 ',
    color_devicons = true,
    file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", "^deps/" },
    theme = "dropdown",
    layout_strategy = 'horizontal',
  },
  pickers = {
    find_files = {
      hidden = true,
      files = true,
      find_command = {'rg', '--files', '--hidden', '-g', '!.git'},
    },
    file_browser = {
      hidden = true,
      files = true,
      find_command = {'rg', '--files', '--hidden', '-g', '!.git'}
    },
    live_grep = {
      -- only_sort_text = true,
    }
  }
}

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
-- EXAMPLE: -g '*stories*' wrapHocs
vim.api.nvim_set_keymap('n', '<leader>fgg', '<cmd>Telescope live_grep<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fgr', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {})
-- vim.api.nvim_set_keymap('n', '-', ':Telescope file_browser path=%:p:h<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ft', ':Telescope file_browser<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fct', ':Telescope file_browser path=%:p:h<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>Telescope resume<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>fp', "<cmd>lua require('telescope').extensions.project.project{}<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>fcr', "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", {})
vim.api.nvim_set_keymap('n', '<leader>ca', "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>", {})

local borderColorscheme = { bg = "#011627", fg = "#c792ea" }

vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#011627" })
vim.api.nvim_set_hl(0, "TelescopeBorder", borderColorscheme)
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", borderColorscheme)
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", borderColorscheme)
vim.api.nvim_set_hl(0, "TelescopePromptBorder", borderColorscheme)
vim.api.nvim_set_hl(0, "TelescopeTitle", borderColorscheme)
