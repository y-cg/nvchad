-- Neogit — Magit-style git interface.
-- Lazy-loaded: only `:Neogit` or <leader>gg triggers it, so sessions that
-- never touch git pay no startup cost.
---@type LazySpec
return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit status" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  -- Keep opts minimal: a few UX tweaks + diffview integration so hunk
  -- navigation lands in a richer split view.
  opts = {
    -- Open the status buffer in a full tab instead of a split — closer to
    -- fullscreen Magit and avoids competing with NvChad's tabufline.
    kind = "tab",

    -- No extra confirmation dialog when staging hunks/lines.
    disable_commit_confirmation = false,

    -- Show each section's diff inline in the status buffer.
    status = {
      recent_commit_count = 20,
    },

    integrations = {
      -- diffview.nvim provides the side-by-side diff UI that Neogit jumps
      -- into on `d` / `D`. It's lazy-loaded by its own plugin spec, so this
      -- is just a capability flag.
      diffview = true,
    },

    -- Pin the navigation/fold mappings we actually rely on. These are all
    -- currently Neogit defaults, but listing them explicitly guards against
    -- upstream keybinding changes silently stealing muscle memory.
    mappings = {
      status = {
        -- Magit-style deep fold: zO expands all hunks in the section under
        -- the cursor; zC collapses back to the section header.
        ["zO"] = "Depth4",
        ["zC"] = "Depth1",

        -- Jump between hunk headers inside the status buffer.
        -- { / } mirrors Vim's paragraph-motion mnemonic (prev/next block).
        ["{"] = "GoToPreviousHunkHeader",
        ["}"] = "GoToNextHunkHeader",
      },
    },
  },
}
