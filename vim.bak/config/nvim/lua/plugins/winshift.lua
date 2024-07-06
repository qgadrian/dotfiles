require("winshift").setup({
  highlight_moving_win = true,  -- Highlight the window being moved
  focused_hl_group = "Visual",  -- The highlight group used for the moving window
  moving_win_options = {
    -- These are local options applied to the moving window while it's
    -- being moved. They are unset when you leave Win-Move mode.
    wrap = false,
    cursorline = false,
    cursorcolumn = false,
    colorcolumn = "",
  }
})

vim.api.nvim_set_keymap('n', '<C-W><C-M>', ':WinShift<CR>', {
  noremap = true,
  silent = false
})

vim.api.nvim_set_keymap('n', '<leader>mw', ':WinShift<CR>', {
  noremap = true,
  silent = false
})
