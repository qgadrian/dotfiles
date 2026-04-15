return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      mode = "tabs",
      name_formatter = function(item)
        if item.tabnr then
          local ok, name = pcall(vim.fn.gettabvar, item.tabnr, "name")
          if ok and type(name) == "string" and name ~= "" then
            return name
          end
        end
        return item.name
      end,
    },
  },
}
