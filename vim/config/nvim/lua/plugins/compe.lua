--vim.api.nvim_command('set completeopt=menuone,noselect')

vim.g.loaded_compe_treesitter = true
vim.g.loaded_compe_snippets_nvim = true
vim.g.loaded_compe_spell = true
vim.g.loaded_compe_tags = true
vim.g.loaded_compe_ultisnips = true
vim.g.loaded_compe_vim_lsc = true
vim.g.loaded_compe_vim_lsp = true

require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'always',
  documentation = {border = 'single'},
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  source = {path = true, buffer = true, nvim_lsp = true, vsnip = true}
}

local opts = {noremap = true, silent = true, expr = true}
vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', opts)
vim.api.nvim_set_keymap('i', '<CR>', 'compe#confirm("<CR>")', opts)
vim.api.nvim_set_keymap('i', '<C-e>', 'compe#close("<C-e>")', opts)
vim.api.nvim_set_keymap('i', '<C-u>', 'compe#scroll({ "delta": +4 })', opts)
vim.api.nvim_set_keymap('i', '<C-d>', 'compe#scroll({ "delta": -4 })', opts)
