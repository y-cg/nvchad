---@type LazySpec
return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  keys = {
    {
      "<leader><leader>",
      function()
        require("fff").find_files()
      end,
      desc = "Find files (fff)",
    },
    {
      "<leader>fw",
      function()
        require("fff").live_grep()
      end,
      desc = "Live grep (fff)",
    },
  },
}
