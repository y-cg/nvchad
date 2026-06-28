-- oil.nvim — edit directories as ordinary buffers (add/remove/rename files
-- the same way you'd edit text)
---@type LazySpec
return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Don't ask for confirmation it's trivial
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      -- Always hide `..` and `.git` even when show_hidden is on.
      is_always_hidden = function(name, _)
        return name == ".." or name == ".git"
      end,
    },
    keymaps = {
      -- Navigation: `gd` to enter dir/file, `<C-o>` to go to parent.
      -- These buffer-local mappings won't conflict with global LSP `gd`
      -- because LSPs do not attach to oil buffers (buftype=acwrite).
      ["gd"] = { "actions.select", mode = "n", desc = "Enter dir / open file" },
      ["<C-o>"] = { "actions.parent", mode = "n", desc = "Go to parent dir" },
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- `-` opens oil at the current buffer's directory. This is a *global* map;
  -- it does not conflict with oil's buffer-local `-` (actions.parent, set via
  -- `keymaps` below), because buffer-local maps take precedence — so `-`
  -- opens oil from a file, and inside oil `-` goes up to the parent dir.
  keys = {
    { "-", "<cmd>Oil<CR>", mode = "n", desc = "Open oil for current dir" },
  },
  -- The official recommendation is not to lazy-load oil — it needs to take
  -- over directory buffers, and lazy-loading is hard to get right in many
  -- edge cases.
  lazy = false,
}
