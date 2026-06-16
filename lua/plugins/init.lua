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

  -- Disable the telescope entry that NvChad pulls in via `import = "nvchad.plugins"`.
  -- We use tv.nvim as the picker instead, and the NvChad defaults for the
  -- telescope-backed keybinds (<leader>f*, <leader>cm, etc.) are explicitly
  -- remapped or no-op'd in lua/mappings.lua.
  { "nvim-telescope/telescope.nvim", enabled = false },

  {
    "alexpasmantier/tv.nvim",
    opts = require "configs.tv",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },

  {
    "andyg/leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    opts = require "configs.leap",
  },

  {
    "tpope/vim-surround",
    lazy = false,
  },

  {
    "lambdalisue/vim-suda",
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
    -- Skip loading entirely when the wakatime API token is missing or empty —
    -- wakatime would otherwise error on every keystroke trying to authenticate.
    cond = function()
      local token_path = vim.fn.expand "~/.wakatime/token"
      return vim.fn.filereadable(token_path) == 1 and vim.fn.getfsize(token_path) > 0
    end,
    lazy = false,
  },
}
