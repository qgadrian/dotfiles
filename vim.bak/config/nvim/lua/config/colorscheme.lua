vim.cmd [[colorscheme nightfly]]
vim.g.nightflyTerminalColors = 1
vim.g.nightflyCursorColor = 1


vim.api.nvim_set_hl(0, 'ConflictMarkerBegin', { fg="#ff0051"})
vim.api.nvim_set_hl(0, 'ConflictMarkerOurs', { fg="#81e838"})
vim.api.nvim_set_hl(0, 'ConflictMarkerSeparator', { fg="#ff0051"})
vim.api.nvim_set_hl(0, 'ConflictMarkerTheirs', { fg="#30d6ff"})
vim.api.nvim_set_hl(0, 'ConflictMarkerEnd', { fg="#ff0051"})
