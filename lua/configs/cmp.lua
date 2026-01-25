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

  return opts
end

return opts
