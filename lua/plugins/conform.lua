-- conform.nvim — multi-language formatter dispatcher
return {
  "stevearc/conform.nvim",
  event = "BufWritePre", -- load before save to support format-on-save
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

  -- Note: the manual format mapping <leader>fm is NOT here — it overrides
  -- NvChad's same-named default and must be set after `require "nvchad.mappings"`,
  -- so it lives in lua/mappings.lua (load-order constraint — see CONTEXT.md).
}
