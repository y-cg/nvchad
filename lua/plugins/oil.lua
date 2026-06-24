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
    keymaps = {
      -- Personal navigation habits, mirroring vim's native jump pair: `gd`
      -- jumps into something, `<C-o>` jumps back out. Here `gd` descends into
      -- the entry under the cursor (a directory -> enter it; a file -> open
      -- it, like <CR>), and `<C-o>` goes back up to the parent directory.
      --
      -- These are oil-buffer-local, so they don't clobber NvChad's LSP `gd`
      -- (Go to definition), which only binds on buffers an LSP attaches to —
      -- and Copilot is disabled on `oil` (see lua/plugins/copilot.lua), so no
      -- LSP attaches here at all.
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
