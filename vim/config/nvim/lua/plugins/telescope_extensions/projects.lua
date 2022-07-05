require("telescope").setup {
  extensions = {
    project = {
      base_dirs = {
        {
          path = "~/workspace",
          max_depth = 2
        },
      },
      hidden_files = true,
      theme = "dropdown"
    }
  },
}

require("telescope").load_extension("project")
