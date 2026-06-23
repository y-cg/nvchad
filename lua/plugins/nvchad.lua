-- ==============================================================================
-- NvChad — base distribution
-- ==============================================================================
--
-- NvChad is loaded as a regular plugin slice so all its configuration lives in
-- one place: the spec, its bundled plugin imports, and the mappings for the
-- NvChad-bundled UI components (tabufline, Comment) that have no standalone
-- slice of their own.

-- The bootstrap spec (lazy=false, branch, import) lives in init.lua because
-- NvChad must be on the runtimepath before "nvchad.plugins" can be resolved.
-- This merge spec adds keys only — lazy merges the two specs automatically.
return {
  "NvChad/NvChad",

  -- -------------------------------------------------------------------------
  -- Tabufline and Comment mappings
  -- -------------------------------------------------------------------------
  -- Both are bundled inside NvChad with no standalone lazy spec, so their
  -- mappings live here rather than in a dedicated slice.
  keys = {
    {
      "<tab>",
      function()
        require("nvchad.tabufline").next()
      end,
      desc = "Next buffer",
    },
    {
      "<S-tab>",
      function()
        require("nvchad.tabufline").prev()
      end,
      desc = "Prev buffer",
    },
    {
      "<S-L>",
      function()
        require("nvchad.tabufline").next()
      end,
      desc = "Next buffer",
    },
    {
      "<S-H>",
      function()
        require("nvchad.tabufline").prev()
      end,
      desc = "Prev buffer",
    },
    {
      "<leader>x",
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      desc = "Close buffer",
    },
    { "<leader>/", "gcc", desc = "Toggle comment", remap = true },
    { "<leader>/", "gc", desc = "Toggle comment", remap = true, mode = "v" },
  },
}
