---@type LazySpec
return {
  "stevearc/conform.nvim",
  -- Before the write, so format-on-save can run.
  event = "BufWritePre",
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
      toml = { "taplo" },
      jsonnet = { "jsonnetfmt" },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
