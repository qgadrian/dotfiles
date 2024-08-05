vim.keymap.set("n", "-", ":Neotree toggle reveal<CR>", { noremap = true })

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    open_files_do_not_replace_types = { "trouble", "qf" },
    window = {
      position = "current",
    },
    filesystem = {
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      follow_current_file = {
        enable = true,
      },
      filtered_items = {
        hide_hidden = true,
        hide_dotfiles = true,
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
        always_show_by_pattern = {
          ".env*",
        },
      },
      commands = {
        -- over write default 'delete' command to 'trash'.
        delete = function(state)
          local inputs = require("neo-tree.ui.inputs")
          local path = state.tree:get_node().path
          local msg = "Are you sure you want to trash " .. path

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({ "trash", vim.fn.fnameescape(path) })
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,

        -- over write default 'delete_visual' command to 'trash' x n.
        delete_visual = function(state, selected_nodes)
          local inputs = require("neo-tree.ui.inputs")

          -- get table items count
          function GetTableLen(tbl)
            local len = 0
            for n in pairs(tbl) do
              len = len + 1
            end
            return len
          end

          local count = GetTableLen(selected_nodes)
          local msg = "Are you sure you want to trash " .. count .. " files ?"

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
            end
            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
      },
    },
    buffers = {
      follow_current_file = {
        enable = true,
      },
    },
  },
}
