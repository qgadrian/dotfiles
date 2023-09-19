require "frecency".setup {
  show_scores = false,
  show_unindexed = true,
  ignore_patterns = { "*.git/*", "*/tmp/*", "*node_modules/*" }
}

require "telescope".load_extension("frecency")

vim.api.nvim_set_keymap('n', '<leader>fcr', "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", {})
