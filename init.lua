vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = "\\"
-- Disable Neovim 0.13+ built-in directory explorer to prevent conflicts with oil.nvim
vim.g.loaded_nvim_dir_plugin = 1

-- GUI integration is only loaded under Neovide; see lua/configs/neovide.lua
if vim.g.neovide then
  require "configs.neovide"
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Feature slices under lua/plugins/ are the whole plugin graph. base46 and
-- nvchad/ui are ordinary slices there; nothing imports the NvChad starter.
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

-- Theme caches are bytecode written by base46. Apply them after plugins load
-- so the statusline (set by nvchad/ui) and treesitter captures pick up colors.
dofile(vim.g.base46_cache .. "defaults")
require("configs.base46-highlights").load()
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "mappings"
