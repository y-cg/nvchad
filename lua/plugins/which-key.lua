-- which-key — leader / prefix popup.
--
-- The starter loaded this on the same keys. There is no :WhichKey in command
-- history, but the popup itself shows whenever a prefix waits out timeoutlen
-- (400ms, see options.lua). Kept so that popup does not disappear.
---@type LazySpec
return {
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
  cmd = "WhichKey",
  opts = function()
    dofile(vim.g.base46_cache .. "whichkey")
    return {}
  end,
}
