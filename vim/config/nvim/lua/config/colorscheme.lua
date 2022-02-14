vim.cmd [[colorscheme nightfly]]
vim.g.nightflyTerminalColors = 1
vim.g.nightflyCursorColor = 1


vim.highlight.create('ConflictMarkerBegin', { guifg="#ff0051"}, false)
vim.highlight.create('ConflictMarkerOurs', { guifg="#81e838"}, false)
vim.highlight.create('ConflictMarkerSeparator', { guifg="#ff0051"}, false)
vim.highlight.create('ConflictMarkerTheirs', { guifg="#30d6ff"}, false)
vim.highlight.create('ConflictMarkerEnd', { guifg="#ff0051"}, false)
