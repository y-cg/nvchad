---@type LazySpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "echasnovski/mini.icons" },
  keys = {
    {
      "<leader>tm",
      function()
        require("render-markdown").toggle()
      end,
      desc = "Toggle render-markdown",
      ft = { "markdown" },
    },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    bullet = {
      icons = { "•", "◦", "▪", "▫" },
    },
  },
}
