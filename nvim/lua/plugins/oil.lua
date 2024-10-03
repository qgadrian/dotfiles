return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<BS>"] = "actions.parent",
      ["<S-H>"] = "actions.toggle_hidden",
      ["<S-R>"] = "actions.refresh",
    },
  },
}
