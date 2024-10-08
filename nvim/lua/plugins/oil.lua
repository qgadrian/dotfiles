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
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name)
        if name == ".DS_Store" then
          return true
        end
      end,
    },
    keymaps = {
      ["<BS>"] = "actions.parent",
      ["<S-H>"] = "actions.toggle_hidden",
      ["<S-R>"] = "actions.refresh",
    },
  },
}
