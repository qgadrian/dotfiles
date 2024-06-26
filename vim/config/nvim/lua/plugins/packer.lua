require('packer').startup({
  function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'Asheq/close-buffers.vim'                                     -- Clear hidden buffers
    use 'mhinz/vim-startify'                                          -- startup screen
    use 'nishigori/increment-activator'                               -- configs for incremented values
    use { "folke/flash.nvim", config = 'require("plugins/flash")' }   -- for quick navigation
    use 'gcmt/taboo.vim'                                              -- tab rename
    use 'mg979/vim-visual-multi'                                      -- multiple cursors
    use { 'cappyzawa/trim.nvim', config = 'require("plugins/trim")' } -- trim trailing whitespaces
    use 'tpope/vim-fugitive'                                          -- git in vim
    use 'tpope/vim-vinegar'
    use 'rhysd/conflict-marker.vim'
    use 'machakann/vim-sandwich'
    use { "chrisgrieser/nvim-early-retirement", config = 'require("plugins/early-retirement")' } -- close inactive buffers after X time
    use {
      'notjedi/nvim-rooter.lua',
      config = function()
        require 'nvim-rooter'.setup {
          rooter_patterns = { '.git' },
          trigger_patterns = { '*' },
          manual = false,
          fallback_to_parent = false,
        }
      end
    }

    use {
      "samjwill/nvim-unception",
      setup = function()
        vim.g.unception_open_buffer_in_new_tab = false
        vim.g.unception_enable_flavor_text = false
      end
    }

    -- Notifications
    use {
      "folke/noice.nvim",
      config = 'require("plugins/noice")',
      requires = {
        "MunifTanjim/nui.nvim",
        { "rcarriga/nvim-notify", config = 'require("plugins/notify")' }
      }
    }

    -- search and replace
    use {
      'nvim-pack/nvim-spectre',
      requires = { "nvim-lua/plenary.nvim" },
      config = 'require("spectre").setup()'
    }

    -- Syntax color
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        {
          'nvim-treesitter/nvim-treesitter-textobjects',
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
    use { 'richardbizik/nvim-toc', ft = 'markdown', config = function()
      require("nvim-toc").setup({ toc_header = "Table of Contents" })
    end }                                                                    -- auto toc
    use { 'sindrets/winshift.nvim', config = 'require("plugins/winshift")' } -- window move
    use { "ellisonleao/glow.nvim", config = function() require("glow").setup() end }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
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
      'levouh/tint.nvim',
      config = 'require("plugins/tint")'
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      config = 'require("plugins/telescope")',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-lua/popup.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
      }
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      config = function()
        require("telescope").load_extension("fzf")
      end
    }

    use {
      "nvim-telescope/telescope-project.nvim",
      config = 'require("plugins/telescope_extensions/projects")'
    }

    use {
      'nvim-telescope/telescope-live-grep-args.nvim',
      config = 'require("plugins/telescope_extensions/live_grep_args")',
      run =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }

    -- file tree
    use {
      "nvim-telescope/telescope-file-browser.nvim",
      config = 'require("plugins/telescope_extensions/telescope-file-browser")'
    }
    -- use {
    --   "nvim-tree/nvim-tree.lua",
    --   config = 'require("plugins/nvim-tree")',
    -- }

    -- monkey code
    use {
      'Exafunction/codeium.vim',
      config = 'require("plugins/codeium")'
    }
    -- use {
    --   'github/copilot.vim',
    --   requires = { 'ofseed/lualine-copilot' },
    --   config = 'require("plugins/copilot")'
    -- }

    -- LSP, formatters...
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
        { 'hrsh7th/cmp-buffer',   after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-emoji',    after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path',     after = 'nvim-cmp' }
      },
      config = 'require("plugins/nvim-cmp")'
    }                                                                     -- completion
    use { 'onsails/lspkind-nvim', config = 'require("plugins/lspkind")' } -- add pictogramas to LSP
    use { 'nvimtools/none-ls.nvim', 
      requires = { "nvimtools/none-ls-extras.nvim" },
      config = 'require("plugins/none-ls")'
    }

    -- diagnostics alerts & visuals
    use {
      "folke/trouble.nvim",
      requires = "nvim-tree/nvim-web-devicons",
      config = 'require("plugins/trouble")'
    }

    use {
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu'
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }
  end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})
