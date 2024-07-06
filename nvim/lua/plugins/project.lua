return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      base_dirs = {
        {
          path = "~/workspace",
          max_depth = 3,
        },
      },
      hidden_files = true,
      theme = "dropdown",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)

      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
  },
}
