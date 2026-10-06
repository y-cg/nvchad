---@type LazySpec
return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  ---@type lean.Config
  opts = {
    mappings = true,
  },
  config = function(_, opts)
    vim.g.lean_config = opts
  end,
}
