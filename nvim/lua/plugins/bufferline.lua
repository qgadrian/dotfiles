-- Tab name formatter for Claude Code sessions.
-- Reads two tabpage vars set by lua/config/autocmds.lua:
--   t:claude_session_name → name from ~/.claude/sessions/<pid>.json (.name)
--   t:claude_status       → one of: action_needed | notify | error | idle | working
-- and prepends a status emoji. Falls back to the bufferline default name for
-- plain shells (no Claude detected in any window of the tab).
local _emoji = {
  action_needed = "⚠️ ",
  notify        = "🔔 ",
  error         = "❌ ",
  idle          = "💬 ",
  working       = "🟢 ",
}

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
        else
          local ok_cs, cs = pcall(vim.api.nvim_tabpage_get_var, tabnr, "claude_session_name")
          if ok_cs and type(cs) == "string" and cs ~= "" then
            display = cs
          end
        end

        local ok_st, status = pcall(vim.api.nvim_tabpage_get_var, tabnr, "claude_status")
        if ok_st and type(status) == "string" then
          local glyph = _emoji[status]
          if glyph then return glyph .. display end
        end

        return display
      end,
    },
  },
}
