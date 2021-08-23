require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'airblade/vim-rooter' -- Automatically cd into projects, needed for the moment
  use 'Asheq/close-buffers.vim' -- Clear hidden buffers
  use 'mhinz/vim-startify' -- startup screen
  use 'nishigori/increment-activator' -- configs for incremented values
  use 'easymotion/vim-easymotion' -- for quick navigation
  use 'gcmt/taboo.vim' -- tab rename
  --use 'akinsho/nvim-bufferline.lua' -- tab plugin suppose to be better than taboo, didn't like it yet. TODO load config here
  use 'ActivityWatch/aw-watcher-vim' -- micromanagement
  use 'mg979/vim-visual-multi' -- multiple cursors
  use 'scrooloose/nerdcommenter' -- useful for toggle comments
  use 'ntpeters/vim-better-whitespace' -- show trailing whitespaces
  use 'tpope/vim-fugitive' -- git in vim

  -- Syntax color
  use 'elixir-editors/vim-elixir'
  use 'vim-ruby/vim-ruby'
  use 'pangloss/vim-javascript'
  use 'mxw/vim-jsx'
  use 'leafgarland/typescript-vim'
  use 'plasticboy/vim-markdown'

  -- Markdown
  use 'godlygeek/tabular'
  -- use 'junegunn/vim-easy-align'
  use { 'JamshedVesuna/vim-markdown-preview', ft = 'markdown', config = 'require("plugins/markdown_preview")' }
  use { 'mzlogin/vim-markdown-toc', ft = 'markdown' } -- auto toc

  -- Statusline
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = 'require("plugins/galaxyline")'
  }

  -- Snippets
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  -- Themes
  use {
    'bluz71/vim-nightfly-guicolors',
    config = 'require("config.colorscheme")'
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    config = 'require("plugins/telescope")',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-lua/popup.nvim'},
      {'kyazdani42/nvim-web-devicons'},
    }
  }

  -- Causing problems at the time, interesting but disabled
  use {
    'nvim-telescope/telescope-frecency.nvim',
    disable = true,
    config = 'require("plugins/telescope_extensions/frecency")',
    requires = {
      {'tami5/sql.nvim'}
    }
  }

  use {
    "ahmedkhalf/project.nvim",
    config = 'require("plugins/telescope_extensions/projects")'
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    --after="nvim-web-devicons",
    disable = false,
    branch = "feat/open-on-dir",
    config = 'require("plugins/nvim_tree")'
  }

  use {
    'scrooloose/nerdtree',
    disable = true,
    requires = {
      {'tiagofumo/vim-nerdtree-syntax-highlight'},
      {'mortonfox/nerdtree-clip'},
      {'tpope/vim-vinegar'}
    }
  }

  -- LSP
  use  { "neovim/nvim-lspconfig", config = 'require("lsp/config")' }
  use 'kabouzeid/nvim-lspinstall' -- auto install language servers
  use 'hrsh7th/nvim-compe' -- completion
  use { 'onsails/lspkind-nvim', config = 'require("plugins/lspkind")' } -- add pictogramas to LSP
end)
