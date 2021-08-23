require("project_nvim").setup {
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { ".git", "package.json", "mix.exs" }
}

vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_respect_buf_cwd = 1

require('telescope').load_extension('projects')
