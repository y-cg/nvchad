return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = require "configs.lazydev",
  },

  -- Start from NvChad's blink integration so we inherit their menu renderer,
  -- theme integration, and the companion snippet/autopairs plugins.
  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = require "configs.blink",
  },

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = require "configs.copilot",
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = require "configs.telescope",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },

  {
    "tpope/vim-surround",
    lazy = false,
  },

  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = require "configs.oil",
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
}
