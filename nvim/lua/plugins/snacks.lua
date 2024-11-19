return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        ---@param keys snacks.dashboard.Item[]
        keys = function(keys)
          -- add LazyExtra before Lazy
          for k, key in ipairs(keys) do
            if key.action == ":Lazy" then
              -- key.key = "l" -- we don't have multiple panes, so `l` is free
              table.insert(keys, k, { icon = " ", desc = "Terminal", action = ":terminal", key = "t" })
              break
            end
          end
        end,
      },
    },
  },
}
