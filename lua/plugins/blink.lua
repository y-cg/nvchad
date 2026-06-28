-- ==============================================================================
-- blink.cmp — autocompletion
-- ==============================================================================
--
-- This slice has two halves:
-- 1. Start from NvChad's blink integration, inheriting their menu renderer,
--    theme integration, and bundled snippet/autopairs plugins.
-- 2. Layer our own sources (lazydev) and keymaps (<Tab> AI coordination)
--    on top.

---@type LazySpec[]
return {
  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
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
      opts.completion.ghost_text = { enabled = false }

      -- ------------------------------------------------------------------------
      -- Keymaps
      -- ------------------------------------------------------------------------
      -- Insert-mode <Tab> is a priority chain (first handler that "consumes" the
      -- key wins; otherwise we fall through):
      --   1. jump to the next snippet placeholder, if mid-snippet;
      --   2. jump to / apply sidekick.nvim's next edit suggestion (NES);
      --   3. accept the native LSP inline completion (Copilot ghost text), if any;
      --   4. fall back to Neovim for indent / user mappings.
      --
      -- Note we intentionally do NOT accept the blink completion-menu item on
      -- <Tab> here (no "select_and_accept") — that mirrors the prior setup, where
      -- <Tab> was reserved for the AI suggestion flow. Snippet jumping stays off
      -- <S-Tab> as before.
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Tab>"] = {
          "snippet_forward",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function() -- native LSP inline completion (Copilot)
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
        ["<S-Tab>"] = false,
      })

      return opts
    end,
  },
}
