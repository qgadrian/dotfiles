require('lualine').setup({
  options = {
    theme = 'dracula'
  },
  sections = {
    lualine_a = {
      { 'mode', padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      {
        'filename',
        path = 1
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' }
      },
      -- 'branch'
    },
    lualine_c = {},
    lualine_x = {
      {
        "copilot",
        show_running = true,
        symbols = {
          running = "🧠",
        }
      },
    },
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {
      {
        'filename',
        path = 1
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
})
