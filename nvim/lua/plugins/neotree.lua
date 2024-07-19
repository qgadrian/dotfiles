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
    },
    buffers = {
      follow_current_file = {
        enable = true,
      },
    },
  },
}
