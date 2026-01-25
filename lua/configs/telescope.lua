local function opts()
  local opts = require "nvchad.configs.telescope"

  opts.pickers = opts.pickers or {}
  opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
    hidden = true,
    find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
  })

  return opts
end

return opts
