-- ==============================================================================
-- base46-highlights — orphaned NvChad syntax / treesitter theme caches
-- ==============================================================================
--
-- Causal chain (why this file exists):
--   Neovim 0.12+ ships built-in treesitter
--     → we replaced nvim-treesitter with tree-sitter-manager + vim.treesitter
--     → NvChad used to dofile these caches from nvim-treesitter opts
--     → that hook is gone, so we load them here instead
--
-- This is NOT parser install or vim.treesitter.start — it only applies NvChad
-- theme colors to highlight groups:
--   syntax     — classic groups (String, Keyword, Function, …)
--   treesitter — capture groups (@keyword, @string, @function, …)
--
-- Division of labour:
--   tree-sitter-manager  — install parsers, parse buffers, attach @ captures
--   this module          — define what color each @ capture uses in the theme
--
-- Must run after `defaults` in init.lua (see init.lua theme section).
local M = {}

function M.load()
  pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end)
end

return M
