local function opts(_, opts)
  local copilot_suggestion = require "copilot.suggestion"

  -- =============================================================================
  -- Source Selection
  -- =============================================================================
  --
  -- NvChad already provides the baseline blink sources. We only layer on the
  -- Lua-specific lazydev source here so the rest of NvChad's defaults keep
  -- flowing through future updates.
  opts.sources = opts.sources or {}
  opts.sources.per_filetype = opts.sources.per_filetype or {}
  opts.sources.providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
    lazydev = {
      name = "LazyDev",
      module = "lazydev.integrations.blink",
      -- Keep `require(...)` and `---@module` completions above plain LuaLS items.
      score_offset = 100,
    },
  })

  local lua_sources = opts.sources.per_filetype.lua or {}
  if lua_sources.inherit_defaults == nil then
    lua_sources.inherit_defaults = true
  end

  if not vim.tbl_contains(lua_sources, "lazydev") then
    table.insert(lua_sources, "lazydev")
  end

  opts.sources.per_filetype.lua = lua_sources

  -- =============================================================================
  -- Completion UX
  -- =============================================================================
  --
  -- The previous nvim-cmp setup enabled ghost text, so we keep the same inline
  -- preview behavior after the migration.
  opts.completion = opts.completion or {}
  opts.completion.ghost_text = { enabled = true }

  -- =============================================================================
  -- Keymaps
  -- =============================================================================
  --
  -- Preserve the existing editing flow:
  -- 1. Copilot owns <Tab> when it has a suggestion.
  -- 2. Otherwise <Tab> accepts the current completion item.
  -- 3. Otherwise Neovim falls back to indenting or any user mapping.
  --
  -- We intentionally keep snippet jumping off of <Tab>/<S-Tab> because the old
  -- nvim-cmp override already replaced that behavior.
  opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Tab>"] = {
      function()
        if copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
          return true
        end
      end,
      "select_and_accept",
      "fallback",
    },
    ["<S-Tab>"] = false,
  })

  return opts
end

return opts
