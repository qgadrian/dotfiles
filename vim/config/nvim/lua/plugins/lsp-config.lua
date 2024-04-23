-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- not sure how and if this is needed, keeping it for reference
  --client.server_capabilities.documentFormattingProvider = true

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gvd', function()
    vim.cmd([[ vsplit ]])
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '<C-s>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  --vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', '<space>ca', '<cmd>:CodeActionMenu<CR>', opts)
  vim.keymap.set('n', '<space>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.keymap.set('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  -- vim.keymap.set('n', 'gca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.keymap.set('n', '[e', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>', opts)
  vim.keymap.set('n', ']e', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "elixirls",
    -- "nextls",
    "eslint",
    "jsonls",
    "lua_ls",
    "stylelint_lsp",
    "tsserver",
    "marksman",
  }
})

-- See configuration docs:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    local opts = {
      on_attach = on_attach,
    }

    local on_attach_disable_formatting = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.document_range_formatting = false
      return on_attach(client, bufnr)
    end

    -- nvim-cmp capabilities
    local client_capabilities = require("cmp_nvim_lsp").default_capabilities()

    opts.capabilities = client_capabilities

    if server_name == "sumneko_lua" then
      opts.settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'use' }
          }
        }
      }
    end

    if server_name == "stylelint_lsp" then
      opts.on_attach = on_attach_disable_formatting
      opts.settings = {
        stylelintplus = {
          filetypes = {
            'css',
            'less',
            'scss',
            'sass',
          },
          cssInJs = false,
        }
      }
    end

    if server_name == "jsonls" then
      opts.on_attach = on_attach
    end

    if server_name == "eslint" then
      opts.settings = {
        enable = true,
        autoFixOnSave = true,
        format = { enable = true }, -- this will enable formatting
        codeActionsOnSave = {
          mode = "all",
          rules = { "!debugger", "!no-only-tests/*" },
        },
        lintTask = {
          enable = true,
        },
        workingDirectory = {
          mode = 'auto'
        }
      }
      opts.flags = { debounce_text_changes = 500 }
      opts.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        if client.server_capabilities.documentFormattingProvider then
          local au_lsp = vim.api.nvim_create_augroup("eslint_lsp", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
            group = au_lsp,
          })
        end
      end
    end

    require("lspconfig")[server_name].setup(opts)
  end,
})

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
vim.keymap.set('n', 'F', '<cmd>Format<CR>')
