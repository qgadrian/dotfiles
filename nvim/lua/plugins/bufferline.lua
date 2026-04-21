return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      mode = "tabs",
      name_formatter = function(item)
        -- bufferline passes the tabpage handle here (not the 1-indexed tab
        -- number), so we must resolve it via the handle-based API — otherwise
        -- names drift to the wrong tab after any tab is closed.
        if item.tabnr and vim.api.nvim_tabpage_is_valid(item.tabnr) then
          local ok, name = pcall(vim.api.nvim_tabpage_get_var, item.tabnr, "name")
          if ok and type(name) == "string" and name ~= "" then
            return name
          end
        end
        return item.name
      end,
    },
  },
}
