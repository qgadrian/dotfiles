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
