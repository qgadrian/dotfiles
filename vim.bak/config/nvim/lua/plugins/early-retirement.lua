require('early-retirement').setup({
  opts = {
    -- if a buffer has been inactive for this many minutes, close it
    retirementAgeMins = 5,

    -- filetypes to ignore
    ignoredFiletypes = {},

    -- ignore files matches this lua pattern (string.find); empty string
    -- disables this setting
    ignoreFilenamePattern = "";

    -- will not close the alternate file
    ignoreAltFile = true,

    -- minimum number of open buffers for auto-closing to become active, e.g.,
    -- by setting this to 4, no auto-closing will take place when you have 3
    -- or less open buffers. Note that this plugin never closes the currently
    -- active buffer, so a number < 2 will effectively disable this setting.
    minimumBufferNum = 3,

    -- will ignore buffers with unsaved changes. If false, the buffers will
    -- automatically be written and then closed.
    ignoreUnsavedChangesBufs = true,

    -- ignore non-empty buftypes, for example terminal buffers
    ignoreSpecialBuftypes = false,

    -- ignore visible buffers ("a" in `:buffers`). buffers open in a window,
    -- or in a tab are consider visible by vim
    ignoreVisibleBufs = true,

    -- ignore unloaded buffers. session-management plugin often add buffers
    -- to the buffer list without loading them
    ignoreUnloadedBufs = false,

    -- uses vim.notify for plugins like nvim-notify
    notificationOnAutoClose = true,
  }
})
