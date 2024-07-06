return {
  "samjwill/nvim-unception",
  event = "VeryLazy",
  setup = function()
    vim.g.unception_open_buffer_in_new_tab = false
    vim.g.unception_enable_flavor_text = false
  end,
}
