-- https://github.com/notjedi/nvim-rooter.lua

require("nvim-tree").setup({
  rooter_patterns = { '.git', '.hg', '.svn' },
  trigger_patterns = { '*' },
  manual = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
})
