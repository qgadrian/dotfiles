vim.api.nvim_set_hl(0, "FlashLabel", { foreground = "#000000", background = "#ed7e9f" })
vim.api.nvim_set_hl(0, "FlashCurrent", { foreground = "#000000", background = "#7eed82" })

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
              match = "#82d7ee",
              current = "#7eed82",
              label = "#ed7e9f",
            },
          },
        },
      },
    },
  },
}
