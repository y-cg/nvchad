---@type LazySpec
return {
  "folke/snacks.nvim",
  event = "VeryLazy",

  opts = {
    picker = {
      enabled = true,
      ui_select = true,
    },

    input = {
      enabled = true,
    },
  },
}
