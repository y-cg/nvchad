local function opts()
  local opts = require "nvchad.configs.cmp"
  local cmp = require "cmp"

  local copilot_suggestion = require "copilot.suggestion"

  opts.sources = opts.sources or {}
  table.insert(opts.sources, {
    name = "lazydev",
    -- set group index to 0 to skip loading LuaLS completions
    group_index = 0,
  })

  opts.completion.completeopt = "menu,menuone"
  opts.experimental = opts.experimental or { ghost_text = true }

  -- Remap Tab and Shift-Tab to navigate copilot suggestions
  opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
    ["<Up>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
        return
      end
    end, { "i", "s" }),
    ["<Down>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
        return
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if copilot_suggestion.is_visible() then
        copilot_suggestion.accept()
      elseif cmp.visible() then
        cmp.confirm { select = true }
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.config.disable,
  })

  return opts
end

return opts
