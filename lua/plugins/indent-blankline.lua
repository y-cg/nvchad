-- indent-blankline — indent guides.
--
-- Previously pulled in by the NvChad starter. No keymaps; the guides are the
-- whole feature. Highlight cache is applied twice because ibl's setup resets
-- groups, matching the old starter config.
---@type LazySpec
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = { char = "│", highlight = "IblChar" },
    scope = { char = "│", highlight = "IblScopeChar" },
  },
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "blankline")

    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    require("ibl").setup(opts)

    dofile(vim.g.base46_cache .. "blankline")
  end,
}
