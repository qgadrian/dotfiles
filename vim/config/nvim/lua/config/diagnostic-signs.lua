local signs = {
  Error = " ",
  Warning = " ",
  Hint = " ",
  Information = " "
}

-- Seems `LspDiagnosticsSign` will change in nvim 0.6 to `DiagnosticSign`
for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end
