require('lualine').setup({
  options = {
    theme = 'dracula'
  },
  sections = {
    lualine_a = {
      { 'mode', padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      'filename',
      {'diagnostics', sources={'nvim_lsp'}},
      'branch'
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'filetype' },
    lualine_z = {
      { 'location', padding = { left = 2 } }
    }
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' }
  },
  tabline = {},
  extensions = {}
})
