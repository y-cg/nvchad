-- gitsigns — git gutter signs.
--
-- Previously pulled in by the NvChad starter on its FilePost autocmd, with no
-- keymaps of our own. This slice keeps the signs and the two sign overrides.
-- gitsigns does not install buffer mappings unless on_attach does, and we
-- don't set one. Git operations stay on neogit / hunk.
---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      delete = { text = "󰍵" },
      changedelete = { text = "󱕖" },
    },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "git")
    require("gitsigns").setup(opts)
  end,
}
