local fb_actions = require "telescope".extensions.file_browser.actions

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "dropdown",
      layout_strategy = 'horizontal',
      hidden = true,
      respect_gitignore = false,
      layout_config = {
        horizontal = { width = 0.8, height = 0.8 }
      },
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<C-a>"] = fb_actions.create,
          ["<C-r>"] = fb_actions.rename,
          ["<C-m>"] = fb_actions.move,
          ["<C-y>"] = fb_actions.copy,
          ["<C-d>"] = fb_actions.remove
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}

-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension("file_browser")
require("telescope").load_extension('fzf')
