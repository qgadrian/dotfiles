vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#000000", bg = "#ed7e9f" })
vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#000000", bg = "#7eed82" })
vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#000000", bg = "#82d7ee" })

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          jump_labels = false,
          multi_line = true,
          highlight = {
            backdrop = true,
            matches = true,
            groups = {
              match = "FlashMatch",
              current = "FlashCurrent",
              label = "FlashLabel",
            },
          },
        },
      },
    },
  },
}
