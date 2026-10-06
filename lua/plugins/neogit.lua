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
  opts = {
    kind = "tab",

    disable_commit_confirmation = false,

    status = {
      recent_commit_count = 20,
    },

    integrations = {
      diffview = true,
    },

    -- Same as upstream defaults; listed so a default change does not move them.
    mappings = {
      status = {
        ["zO"] = "Depth4",
        ["zC"] = "Depth1",

        ["{"] = "GoToPreviousHunkHeader",
        ["}"] = "GoToNextHunkHeader",
      },
    },
  },
}
