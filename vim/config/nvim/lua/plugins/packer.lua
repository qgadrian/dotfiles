require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'airblade/vim-rooter' -- Automatically cd into projects, needed for the moment
  use 'Asheq/close-buffers.vim' -- Clear hidden buffers
  use 'mhinz/vim-startify' -- startup screen
  use 'nishigori/increment-activator' -- configs for incremented values
  use { 'easymotion/vim-easymotion', config = 'require("plugins/easymotion")' } -- for quick navigation
  use 'gcmt/taboo.vim' -- tab rename
  -- use 'ActivityWatch/aw-watcher-vim' -- micromanagement
  use 'mg979/vim-visual-multi' -- multiple cursors
  use 'ntpeters/vim-better-whitespace' -- show trailing whitespaces
  use 'tpope/vim-fugitive' -- git in vim
  use 'tpope/vim-vinegar'
  use 'rhysd/conflict-marker.vim'
  use 'machakann/vim-sandwich'

  -- Syntax color
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      {
        'lewis6991/spellsitter.nvim',
        config = function()
          require('spellsitter').setup()
        end
      },
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require'treesitter-context'.setup()
        end
      }
    },
    config = 'require("plugins/_nvim-treesitter")',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  -- code comments
  use { 'numToStr/Comment.nvim', config = 'require("plugins/comment")' }
  -- use { "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim", config = 'require("plugins/todo-comments")' }

  -- Markdown
  use 'godlygeek/tabular'
  -- use 'junegunn/vim-easy-align'
  use { 'JamshedVesuna/vim-markdown-preview', ft = 'markdown', config = require("plugins/markdown_preview") }
  use { 'mzlogin/vim-markdown-toc', ft = 'markdown' } -- auto toc
  use { 'sindrets/winshift.nvim', config = 'require("plugins/winshift")' } -- window move

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = 'require("plugins/lualine")'
  }

  -- Snippets
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/cmp-vsnip'

  -- Themes
  use {
    'bluz71/vim-nightfly-guicolors',
    config = 'require("config.colorscheme")'
  }
  use {
    'sunjon/shade.nvim',
    config = 'require("plugins/shade")'
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    config = 'require("plugins/telescope")',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'kyazdani42/nvim-web-devicons' },
    }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  use {
    "nvim-telescope/telescope-project.nvim",
    config = 'require("plugins/telescope_extensions/projects")'
  }

  use {
    'nvim-telescope/telescope-live-grep-args.nvim',
    config = 'require("plugins/telescope_extensions/live_grep_args")',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }

  -- file tree
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    config = 'require("plugins/telescope_extensions/telescope-file-browser")'
  }

  -- LSP
  use {
    "williamboman/mason.nvim",
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = 'require("plugins/lsp-config")',
    after = 'cmp-nvim-lsp'
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    },
    config = 'require("plugins/nvim-cmp")'
  } -- completion
  use { 'onsails/lspkind-nvim', config = 'require("plugins/lspkind")' } -- add pictogramas to LSP

  -- diagnostics alerts & visuals
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = 'require("plugins/trouble")'
  }

  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu'
  })
end)
