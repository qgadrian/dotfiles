local flash = require("flash")

flash.setup({
  opts = {},
})

vim.keymap.set({ "n", "x", "o" }, "e", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "E",
  function() flash.jump({ search = { forward = false, wrap = false, multi_window = false } }) end, { desc = "Flash" })
-- vim.keymap.set({ "n", "o", "x" }, "E", function() flash.treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Flash Treesitter Search" })
vim.keymap.set({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
