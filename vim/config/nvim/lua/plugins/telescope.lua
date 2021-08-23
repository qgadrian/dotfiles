require('telescope').setup {
  defaults = {
    prompt_prefix = '🔍 ',
    color_devicons = true
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
