return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "moon",
    on_colors = function(colors)
      colors.border = "#565f89"
    end,
  },
}
