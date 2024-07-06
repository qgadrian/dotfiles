vim.api.nvim_create_user_command(
    'GR',
    function(opts)
        os.execute('gr '..opts.args)
    end,
    { nargs = '+' }
)
