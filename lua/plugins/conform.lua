-- conform.nvim — multi-language formatter dispatcher
---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = "BufWritePre", -- load before save to support format-on-save
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format()
      end,
      desc = "Format file",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      python = { "ruff_format" },
      json = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      nix = { "nixfmt" },
    },

    format_on_save = {
      -- Options forwarded to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
