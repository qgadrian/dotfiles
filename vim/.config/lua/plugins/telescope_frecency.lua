--require"telescope".load_extension("frecency")
--requires = {"tami5/sql.nvim"}

local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        prompt_prefix = '>',
        color_devicons = true,

        --mappings = {
            --i = {
                --["<C-x>"] = false,
                --["<C-q>"] = actions.send_to_qflist,
            --},
        --}
    },
    extensions = {
        --fzy_native = {
            --override_generic_sorter = false,
            --override_file_sorter = true,
        --},
        frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
        }
    }
}

--require('telescope').load_extension('fzy_native')
require('telescope').load_extension('frecency')
