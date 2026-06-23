-- vim-suda — transparently read/write read-only files with sudo (no need to
-- reopen nvim as root)
return {
  "lambdalisue/vim-suda",
  lazy = false,
  -- The suda toggle originally lived in init.lua; moved here for locality
  -- (see CONTEXT.md). smart_edit: auto-detect permission-denied files and
  -- switch to suda read/write.
  init = function()
    vim.g.suda_smart_edit = 1
  end,
}
