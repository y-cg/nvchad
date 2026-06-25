-- tree-sitter-manager — parser installer for Neovim 0.12+ native vim.treesitter
---@type LazySpec[]
return {
  -- Disable nvim-treesitter pulled in by NvChad via `import = "nvchad.plugins"`.
  { "nvim-treesitter/nvim-treesitter", enabled = false },

  {
    "romus204/tree-sitter-manager.nvim",
    -- Must load at startup: lazy-loading on BufReadPost misses the first FileType
    -- event, so highlighting only appears after a later trigger (e.g. :w).
    lazy = false,
    cmd = { "TSManager", "TSInstall", "TSUninstall", "TSUpdate" },
    opts = {
      auto_install = true,
      ensure_installed = {
        "c",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "luadoc",
        "printf",
        "html",
        "css",
        "nix",
        "json",
        "toml",
        "rust",
      },
    },
    config = function(_, opts)
      require("tree-sitter-manager").setup(opts)
    end,
  },
}
