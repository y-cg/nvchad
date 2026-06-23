-- oil.nvim — edit directories as ordinary buffers (add/remove/rename files
-- the same way you'd edit text)
---@type LazySpec
return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
      -- Always hide `..` and `.git` even when show_hidden is on.
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- The official recommendation is not to lazy-load oil — it needs to take
  -- over directory buffers, and lazy-loading is hard to get right in many
  -- edge cases.
  lazy = false,
}
