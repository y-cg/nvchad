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

  -- First require is after nvchad/ui (`lazy = false` above) is on the path.
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },
}
