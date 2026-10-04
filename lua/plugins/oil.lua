---@type LazySpec
return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
    keymaps = {
      -- Buffer-local. LSP does not attach here (buftype=acwrite), so this does not steal `gd`.
      ["gd"] = { "actions.select", mode = "n", desc = "Enter dir / open file" },
      ["<C-o>"] = { "actions.parent", mode = "n", desc = "Go to parent dir" },
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- Global `-` opens oil. Inside an oil buffer the buffer-local `-` (parent) wins.
  keys = {
    { "-", "<cmd>Oil<CR>", mode = "n", desc = "Open oil for current dir" },
  },
  -- Has to take over directory buffers at startup; lazy-loading misses edge cases.
  lazy = false,
}
