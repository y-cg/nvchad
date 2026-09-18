---@type LazySpec
return {
  "nvim-mini/mini.nvim",

  lazy = false,

  -- Supplies queries/<lang>/textobjects.scm (@function.outer / @function.inner)
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },

  config = function()
    local ai = require "mini.ai"
    ai.setup {
      custom_textobjects = {
        f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
      },
    }
  end,
}
