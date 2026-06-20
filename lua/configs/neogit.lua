-- Neogit (https://github.com/NeogitOrg/neogit) acts as our Magit-style git
-- porcelain. We keep the option surface small: a couple of UX tweaks plus
-- diffview integration so hunk navigation lands in the richer split view.
return {
  -- Open the status buffer in the current window rather than a split — feels
  -- closer to a full-screen Magit and avoids fighting NvChad's tabufline.
  kind = "tab",

  -- Stage hunks/lines without an extra confirmation prompt.
  disable_commit_confirmation = false,

  -- Show the per-section diffs inline in the status buffer.
  status = {
    recent_commit_count = 20,
  },

  integrations = {
    -- diffview.nvim provides the side-by-side diff UI Neogit jumps into on
    -- `d` / `D`. It's loaded lazily by the plugin spec so requiring it here
    -- is just a capability flag.
    diffview = true,
  },
}
