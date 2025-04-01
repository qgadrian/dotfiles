return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true,
        },
      },
    })
    telescope.load_extension("live_grep_args")
  end,
}
