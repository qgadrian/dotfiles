return {
  {
    "mason-org/mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
    opts = {
      -- Mason package names (not lspconfig server names). LSP servers come from
      -- the LazyVim lang extras (vtsls, elixir-ls, eslint-lsp, json-lsp, ...).
      ensure_installed = {
        "shfmt",
        "stylua",
      },
    },
  },
}
