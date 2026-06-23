-- ==============================================================================
-- blink.cmp — autocompletion
-- ==============================================================================
--
-- This slice has two halves:
-- 1. Start from NvChad's blink integration, inheriting their menu renderer,
--    theme integration, and bundled snippet/autopairs plugins.
-- 2. Layer our own sources (lazydev) and keymaps (Copilot/<Tab> coordination)
--    on top.

---@type LazySpec[]
return {
  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local copilot_suggestion = require "copilot.suggestion"

      -- ------------------------------------------------------------------------
      -- Source selection
      -- ------------------------------------------------------------------------
      -- NvChad already provides the base blink sources; we only add the
      -- Lua-specific lazydev source on top, letting NvChad's other defaults
      -- continue to flow through future updates.
      opts.sources = opts.sources or {}
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- Rank require(...) and ---@module completions above plain LuaLS items.
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

      -- ------------------------------------------------------------------------
      -- Completion UX
      -- ------------------------------------------------------------------------
      -- The previous nvim-cmp setup had ghost text enabled; preserve the same
      -- inline preview behavior after migration.
      opts.completion = opts.completion or {}
      opts.completion.ghost_text = { enabled = true }

      -- ------------------------------------------------------------------------
      -- Keymaps
      -- ------------------------------------------------------------------------
      -- Preserve the existing editing flow:
      -- 1. When a Copilot suggestion is visible, <Tab> accepts it.
      -- 2. Otherwise <Tab> accepts the current completion item.
      -- 3. Otherwise fall back to Neovim for indent / user mappings.
      --
      -- Snippet jumping is intentionally NOT on <Tab>/<S-Tab> — that behavior
      -- was already replaced by the old nvim-cmp override.
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
    end,
  },
}
