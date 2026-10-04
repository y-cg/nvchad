vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = "\\"
-- Disable the built-in directory explorer; it fights oil.
vim.g.loaded_nvim_dir_plugin = 1

if vim.g.neovide then
  require "configs.neovide"
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

-- base46 writes these as bytecode; apply them after plugins load.
dofile(vim.g.base46_cache .. "defaults")
require("configs.base46-highlights").load()
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "mappings"
