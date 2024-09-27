return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("codeium"))
  end,
}
