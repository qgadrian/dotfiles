vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  hijack_unnamed_buffer_when_opening = true,
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = {
        width = 100,
        height = 80,
        border = "rounded",
        relative = "editor",
      },
    }
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    },
  },
  -- on_attach = function()
  --   local api = require('nvim-tree.api')
  --
  --   local function opts(desc)
  --     return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  --   end
  --
  --    vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  -- end,
})

vim.api.nvim_set_keymap('n', '-', ':NvimTreeFindFileToggle<CR>', { noremap = true })
