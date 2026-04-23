return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      mode = "tabs",
      name_formatter = function(item)
        local tabnr = item.tabnr
        if not tabnr or not vim.api.nvim_tabpage_is_valid(tabnr) then
          return item.name
        end

        local display = item.name
        local ok_name, name = pcall(vim.api.nvim_tabpage_get_var, tabnr, "name")
        if ok_name and type(name) == "string" and name ~= "" then
          display = name
        end

        local ok_attn, _ = pcall(vim.api.nvim_tabpage_get_var, tabnr, "peon_attention")
        if ok_attn then
          return "[*] " .. display
        end

        return display
      end,
    },
  },
}
