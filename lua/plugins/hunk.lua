---@type LazySpec
return {
  "julienvincent/hunk.nvim",
  cmd = { "DiffEditor" },
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("hunk").setup({
      hooks = {
        on_tree_mount = function(ctx)
          vim.api.nvim_set_option_value("wrap", false, { win = ctx.opts.winid })
          vim.api.nvim_set_option_value("linebreak", false, { win = ctx.opts.winid })
        end,
        on_diff_mount = function(ctx)
          vim.api.nvim_set_option_value("wrap", false, { win = ctx.win })
          vim.api.nvim_set_option_value("linebreak", false, { win = ctx.win })
        end,
      },
    })
  end,
}
