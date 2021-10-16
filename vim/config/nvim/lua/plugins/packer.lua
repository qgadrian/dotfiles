require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'airblade/vim-rooter' -- Automatically cd into projects, needed for the moment
  use 'Asheq/close-buffers.vim' -- Clear hidden buffers
  use 'mhinz/vim-startify' -- startup screen
  use 'nishigori/increment-activator' -- configs for incremented values
  use { 'easymotion/vim-easymotion', config = 'require("plugins/easymotion")' } -- for quick navigation
  use 'gcmt/taboo.vim' -- tab rename
  --use 'akinsho/nvim-bufferline.lua' -- tab plugin suppose to be better than taboo, didn't like it yet. TODO load config here
  use 'ActivityWatch/aw-watcher-vim' -- micromanagement
  use 'mg979/vim-visual-multi' -- multiple cursors
  use { 'scrooloose/nerdcommenter', config = 'require("plugins/nerdcommenter")' } -- useful for toggle comments
  use 'ntpeters/vim-better-whitespace' -- show trailing whitespaces
  use 'tpope/vim-fugitive' -- git in vim
  use 'tpope/vim-vinegar'

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
  use { 'sindrets/winshift.nvim', config = 'require("plugins/winshift")' } -- window move

  -- Statusline
  --use {
    --'glepnir/galaxyline.nvim',
    --branch = 'main',
    --config = 'require("plugins/galaxyline")'
  --}
  use {
    'shadmansaleh/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = 'require("plugins/lualine")'
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

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    after = 'cmp-nvim-lsp',
    config = 'require("lsp/config")'
  }
  use { 'williamboman/nvim-lsp-installer' }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      {'hrsh7th/cmp-buffer', after = 'nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'},
      {'hrsh7th/cmp-emoji', after = 'nvim-cmp'},
      {'hrsh7th/cmp-path', after = 'nvim-cmp'}
    },
    config = 'require("plugins/nvim-cmp")'
  } -- completion
  use { 'onsails/lspkind-nvim', config = 'require("plugins/lspkind")' } -- add pictogramas to LSP
end)
