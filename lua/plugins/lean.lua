---@type LazySpec
return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  ---@type lean.Config
  opts = { -- see the manual for full configuration options
    mappings = true,
  },
  config = function(_, opts)
    vim.g.lean_config = opts
  end,
}
