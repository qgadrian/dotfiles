require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "elixir", "lua", "typescript", "javascript" },
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  indent = { enable = true },
  endwise = { enable = true },
  autotag = {
    enable = true,
    filetypes = {
      'html',
      'njk', 'jinja', 'nunjucks',
      'js', 'javascript',
      'jsx', 'javascriptreact',
      'md', 'markdown',
      'svelte',
      'ts','typescript',
      'tsx', 'typescriptreact',
      'vue'
    }
  },
}

vim.api.nvim_command('set foldmethod=expr')
vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
