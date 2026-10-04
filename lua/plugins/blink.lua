-- ==============================================================================
-- blink.cmp — autocompletion
-- ==============================================================================
--
-- Spec is ours. The completion menu renderer and its icons still come from
-- nvchad/ui (`nvchad.blink`.menu) so the popup matches the base46 theme.
-- LuaSnip loads friendly-snippets; we do not go through nvchad.configs.luasnip.

---@type LazySpec
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdLineEnter" },

  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        local luasnip = require "luasnip"
        luasnip.config.set_config(opts)
        require("luasnip.loaders.from_vscode").lazy_load()

        -- https://github.com/L3MON4D3/LuaSnip/issues/258
        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
              luasnip.unlink_current()
            end
          end,
        })
      end,
    },
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "vim" },
      },
    },
  },

  opts_extend = { "sources.default" },

  opts = function()
    dofile(vim.g.base46_cache .. "blink")

    return {
      snippets = { preset = "luasnip" },
      cmdline = { enabled = true },
      appearance = { nerd_font_variant = "normal" },
      fuzzy = { implementation = "prefer_rust" },

      sources = {
        default = { "lsp", "snippets", "buffer", "path" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- Rank require(...) and ---@module completions above plain LuaLS items.
            score_offset = 100,
          },
        },
      },

      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        -- Insert-mode <Tab> is a priority chain (first handler that consumes
        -- the key wins):
        --   1. jump to the next snippet placeholder, if mid-snippet;
        --   2. jump to / apply sidekick.nvim's next edit suggestion (NES);
        --   3. accept the native LSP inline completion (Copilot ghost text);
        --   4. fall back to Neovim for indent / user mappings.
        -- <Tab> does not accept the blink menu item.
        ["<Tab>"] = {
          "snippet_forward",
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          function()
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
        ["<S-Tab>"] = false,
      },

      completion = {
        ghost_text = { enabled = false },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "single" },
        },
        menu = require("nvchad.blink").menu,
      },
    }
  end,
}
