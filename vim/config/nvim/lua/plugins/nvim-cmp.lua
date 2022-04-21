local cmp = require'cmp'
local lspkind = require('lspkind')
local mapping = require('cmp.config.mapping')
local types = require('cmp.types')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {completeopt = 'menu,menuone,noinsert'},
  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'emoji' },
    { name = 'path' }
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Down>'] = mapping({
      i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
      c = function(fallback)
        local cmp = require('cmp')
        cmp.close()
        vim.schedule(cmp.suspend())
        fallback()
      end,
    }),
    ['<Up>'] = mapping({
      i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
      c = function(fallback)
        local cmp = require('cmp')
        cmp.close()
        vim.schedule(cmp.suspend())
        fallback()
      end,
    }),
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end
  }
})
