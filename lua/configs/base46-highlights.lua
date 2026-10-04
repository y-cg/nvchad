-- No plugin loads these highlight caches.
local M = {}

function M.load()
  pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end)
end

return M
