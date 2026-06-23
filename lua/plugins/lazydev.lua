-- lazydev.nvim — Lua LSP type completions for Neovim / plugin development
---@type LazySpec
return {
  "folke/lazydev.nvim",
  ft = "lua", -- only loaded for Lua files
  opts = {
    library = {
      -- Load luvit types when `vim.uv` appears in the code.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
