-- ==============================================================================
-- fff.nvim — fast file finder
-- ==============================================================================
--
-- fff (freakin' fast fuzzy finder) is an index-backed file search engine with a
-- Rust core providing typo-resistant fuzzy path matching and frecency memory.
--
-- Mapping ownership: <leader><leader> and <leader>fw are owned by this slice.
-- Other pickers (files on \ff, git log, definitions, etc.) remain in tv.nvim.

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
