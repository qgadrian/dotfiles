require("telescope").setup {
  extensions = {
    project = {
      base_dirs = {
        {
          path = "~/workspace",
          max_depth = 3
        },
      },
      hidden_files = true,
      theme = "dropdown"
    }
  },
}

require("telescope").load_extension("project")

vim.api.nvim_set_keymap('n', '<leader>fp', "<cmd>lua require('telescope').extensions.project.project{}<cr>", {})
