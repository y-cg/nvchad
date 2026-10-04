-- base46 + nvchad/ui — theme, statusline, tabufline.
--
-- These are ordinary plugin slices. The NvChad starter (NvChad/NvChad and
-- `import = "nvchad.plugins"`) is not loaded, so Telescope, nvim-tree, mason,
-- nvim-cmp, and nvim-treesitter do not come along.
--
-- chadrc.lua is still read by nvchad/ui (via nvconfig). vim.g.base46_cache is
-- set in init.lua before lazy.setup, which is what the highlight caches need.

---@type LazySpec[]
return {
  {
    "nvchad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    dependencies = { "nvchad/base46" },
    config = function()
      require "nvchad"
    end,

    -- Tabufline has no slice of its own; the keys travel with the ui plugin.
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
    },
  },

  -- Icon theme. opts run when some plugin first requires devicons, which is
  -- after nvchad/ui is on the runtimepath (ui is lazy = false).
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },
}
