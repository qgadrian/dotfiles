local util = require("lspconfig.util")

local function get_root_dir(fname)
  return util.root_pattern("tsconfig.json")(fname) or util.root_pattern("package.json", ".git")(fname)
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      tsserver = function(_, opts)
        -- Set the root_dir function for tsserver
        opts.root_dir = get_root_dir

        -- Call the default setup function with modified options
        require("lspconfig").tsserver.setup(opts)

        -- Return true to indicate custom setup is complete
        return true
      end,
    },
  },
}
