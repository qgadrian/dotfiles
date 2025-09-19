return {
  {
    "mason-org/mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
    opts = {
      ensure_installed = {
        "elixirls",
        "nextls",
        "eslint",
        "jsonls",
        "lua_ls",
        "marksman",
        "shfmt",
        "stylelint_lsp",
        "stylua",
        "tsserver",
        "typos-ls",
      },
    },
  },
}
