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

        -- Leaving insert mode mid-snippet otherwise leaves the session stuck.
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

  opts = {
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
      -- First handler that consumes the key wins. Menu accept is intentionally absent.
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
    },
  },
}
