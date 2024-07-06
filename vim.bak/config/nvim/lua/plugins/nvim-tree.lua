vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- copy default mappings here from defaults in next section
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  ---
  -- OR use all default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- remove a default
  vim.keymap.del('n', '<C-]>', { buffer = bufnr })

  -- override a default
  -- vim.keymap.set('n', '<C-e>', api.tree.reload,                       opts('Refresh'))

  -- add your mappings
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', '<C-l>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  ---
end

-- local function toggle_replace()
--   local api = require("nvim-tree.api")
--   if api.tree.is_visible() then
--     api.tree.close()
--   else
--     api.node.open.replace_tree_buffer()
--   end
-- end

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
  hijack_unnamed_buffer_when_opening = false,
  hijack_netrw = false,
  hijack_directories = {
    enable = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  view = {
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * 0.5
        local window_h = screen_h * 0.8
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
        return {
          border = 'rounded',
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    },
  },
  on_attach = my_on_attach,
})

-- vim.api.nvim_set_keymap('n', '-', ':NvimTreeFindFileToggle<CR>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-e>', ':lua 	require"nvim-tree".open_replacing_current_buffer()<CR>', { noremap = true })
