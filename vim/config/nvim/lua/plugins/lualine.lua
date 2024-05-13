require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'dracula',
    disabled_filetypes = {},
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
      'branch',
      'diagnostics',
      {
        'diff',
        colored = true,
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        diff_color = {
          added = { fg = '#a9b665' },
          modified = { fg = '#ebcb8b' },
          removed = { fg = '#bf616a' }
        }
      },
      -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
      -- {
      --   -- only show when recording
      --   require("noice").api.statusline.mode.get,
      --   cond = require("noice").api.statusline.mode.has,
      --   color = { fg = "#ff9e64" },
      -- },
      -- https://github.com/ofseed/copilot-status.nvim
      {
        "copilot",
        show_running = true,
        symbols = {
          status = {
            running = "🧠",
            enabled = "󰊤"
          },
          spinners = require("copilot-status.spinners").dots,
        }
      },
    },
    lualine_y = {
    },
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
