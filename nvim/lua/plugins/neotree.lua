vim.keymap.set("n", "-", ":Neotree toggle<CR>", { noremap = true })

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "current",
    },
  },
}
