-- Shape is nvchad/ui's nvconfig: https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
}

-- noice's auto_open handles signatures without NvChad's focus-stealing autocmd.
M.lsp = { signature = false }

return M
