local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- not sure how and if this is needed, keeping it for reference
  --client.server_capabilities.document_formatting = true

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  buf_set_keymap('n', 'gca', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- neovim's LSP client does not currently support dynamic capabilities registration, so we need to set
-- the server capabilities of the eslint server ourselves!
--
-- @param #boolean allow_formatting whether to enable formating
-- @param #boolean format_on_save   whether to enable format on save
--
local function toggle_formatting(allow_formatting, format_on_save)
  return function(client, bufnr)
    -- default_on_attach(client)

    client.server_capabilities.document_formatting = allow_formatting
    client.server_capabilities.document_range_formatting = allow_formatting

    -- format on save
    if format_on_save then
      vim.cmd([[
      augroup LspFormatting
      autocmd! * <buffer>
      autocmd BufWritePre * sleep 50m
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
      ]])
    end
  end
end

-- Advanced configuration docs:
-- https://github.com/williamboman/nvim-lsp-installer/wiki/Advanced-Configuration
local lsp_installer = require("nvim-lsp-installer")

-- See LSP server configurations documentation:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
  }

  -- nvim-cmp capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  opts.capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  if server.name == "tsserver" then
    on_attach = toggle_formatting(false, false)

    opts.settings = {
      format = { enable = false },
    }
  end

  if server.name == "stylelint_lsp" then
    on_attach = toggle_formatting(true, true)

    opts.filetypes = {
      'css',
      'less',
      'scss',
      'sass',
    }

    opts.settings = {
      stylelintplus = {
        cssInJs = false,
      },
    }
  end

  if server.name == "eslint" then
    on_attach = toggle_formatting(true, true)

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
    }
  end

  if server.name == "elixirls" then
    on_attach = toggle_formatting(true, true)
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
