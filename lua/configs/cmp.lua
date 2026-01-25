local function opts()
  local opts = require "nvchad.configs.cmp"
  local cmp = require "cmp"

  opts.sources = opts.sources or {}
  table.insert(opts.sources, {
    name = "lazydev",
    -- set group index to 0 to skip loading LuaLS completions
    group_index = 0,
  })

  -- I prefer not to select the first one (noselect)
  -- see https://github.com/hrsh7th/nvim-cmp/discussions/1411#discussioncomment-4755441
  opts.preselect = cmp.PreselectMode.None
  opts.completion.completeopt = "menu,menuone,noselect"
  opts.experimental = opts.experimental or { ghost_text = true }

  -- Remap Tab and Shift-Tab to navigate copilot suggestions
  local tab_mapping = opts.mapping and opts.mapping["<Tab>"]
  local shift_tab_mapping = opts.mapping and opts.mapping["<S-Tab>"]

  opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
    ["<Up>"] = shift_tab_mapping,
    ["<Down>"] = tab_mapping,
    ["<Tab>"] = cmp.config.disable,
    ["<S-Tab>"] = cmp.config.disable,
  })

  return opts
end

return opts
