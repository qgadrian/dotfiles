-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/adrian/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/adrian/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/adrian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/adrian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/adrian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["aw-watcher-vim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/aw-watcher-vim"
  },
  ["close-buffers.vim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/close-buffers.vim"
  },
  ["cmp-buffer"] = {
    after_files = { "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-buffer"
  },
  ["cmp-emoji"] = {
    after_files = { "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-emoji/after/plugin/cmp_emoji.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    after = { "nvim-lspconfig" },
    after_files = { "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    after_files = { "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/cmp-path"
  },
  ["galaxyline.nvim"] = {
    config = { 'require("plugins/galaxyline")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["increment-activator"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/increment-activator"
  },
  ["lspkind-nvim"] = {
    config = { 'require("plugins/lspkind")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  nerdcommenter = {
    config = { 'require("plugins/nerdcommenter")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nvim-cmp"] = {
    after = { "cmp-buffer", "cmp-emoji", "cmp-path", "cmp-nvim-lsp" },
    loaded = true,
    only_config = true
  },
  ["nvim-lspconfig"] = {
    config = { 'require("lsp/config")' },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    config = { 'require("plugins/nvim_tree")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["project.nvim"] = {
    config = { 'require("plugins/telescope_extensions/projects")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/project.nvim"
  },
  ["taboo.vim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/taboo.vim"
  },
  tabular = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/tabular"
  },
  ["telescope.nvim"] = {
    config = { 'require("plugins/telescope")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["typescript-vim"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/typescript-vim"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-easymotion"] = {
    config = { 'require("plugins/easymotion")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-easymotion"
  },
  ["vim-elixir"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-elixir"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-javascript"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-javascript"
  },
  ["vim-jsx"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-jsx"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-markdown-preview"] = {
    config = { 'require("plugins/markdown_preview")' },
    loaded = false,
    needs_bufread = false,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/vim-markdown-preview"
  },
  ["vim-markdown-toc"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/opt/vim-markdown-toc"
  },
  ["vim-nightfly-guicolors"] = {
    config = { 'require("config.colorscheme")' },
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-nightfly-guicolors"
  },
  ["vim-rooter"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-ruby"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-ruby"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-visual-multi"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-visual-multi"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/adrian/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require("plugins/telescope")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
require("plugins/nvim_tree")
time([[Config for nvim-tree.lua]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
require("plugins/galaxyline")
time([[Config for galaxyline.nvim]], false)
-- Config for: vim-easymotion
time([[Config for vim-easymotion]], true)
require("plugins/easymotion")
time([[Config for vim-easymotion]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require("plugins/nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
require("plugins/lspkind")
time([[Config for lspkind-nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
require("plugins/telescope_extensions/projects")
time([[Config for project.nvim]], false)
-- Config for: nerdcommenter
time([[Config for nerdcommenter]], true)
require("plugins/nerdcommenter")
time([[Config for nerdcommenter]], false)
-- Config for: vim-nightfly-guicolors
time([[Config for vim-nightfly-guicolors]], true)
require("config.colorscheme")
time([[Config for vim-nightfly-guicolors]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd cmp-buffer ]]
vim.cmd [[ packadd cmp-path ]]
vim.cmd [[ packadd cmp-nvim-lsp ]]
vim.cmd [[ packadd nvim-lspconfig ]]

-- Config for: nvim-lspconfig
require("lsp/config")

vim.cmd [[ packadd cmp-emoji ]]
time([[Sequenced loading]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-markdown-preview', 'vim-markdown-toc'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/adrian/.local/share/nvim/site/pack/packer/opt/vim-markdown-toc/ftdetect/markdown.vim]], true)
vim.cmd [[source /Users/adrian/.local/share/nvim/site/pack/packer/opt/vim-markdown-toc/ftdetect/markdown.vim]]
time([[Sourcing ftdetect script at: /Users/adrian/.local/share/nvim/site/pack/packer/opt/vim-markdown-toc/ftdetect/markdown.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
