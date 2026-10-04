-- nvim-lspconfig — LSP server registration and per-buffer on_attach behavior
--
-- Capabilities: blink.cmp registers its own LSP capabilities when using
-- `vim.lsp.config` (Neovim 0.11+), so no explicit `capabilities` wiring is
-- needed here. TODO: revisit if we stop using `vim.lsp.config`.
--
-- Load timing: `lazy = false` is explicit because adding a `keys` field would
-- otherwise make lazy.nvim lazy-load this plugin on those keys — which would
-- stop LSP servers from starting when a file is opened. lspconfig must load at
-- startup; the `keys` below are set at startup, not used as load triggers.
--
-- Global diagnostic/code-action mappings (<leader>f, <leader>qf) call the
-- vim.diagnostic / vim.lsp builtins, but this repo's only path to a working
-- LSP is this slice — so the mappings live here and travel with it. See
-- CONTEXT.md "Mappings that call a builtin API but only matter under a plugin".
--
-- Server registry shape: `servers` is a name → entry table, the single source
-- of truth for both registration and `vim.lsp.enable`. Each entry holds the
-- opts merged into `vim.lsp.config`, plus one reserved key:
--   * setup — optional thunk run ONCE at registration time, before enable.
--             Use it for wiring a server needs that isn't LSP opts (e.g.
--             buf_ls registers its config filetypes). Defaults to absent = no-op.
-- Everything else in an entry is forwarded to `vim.lsp.config` verbatim.
--
-- Language-specific entries that aren't the stock `name = {}` live in siblings
-- that RETURN their entry (pure data, no side effects, no require-order
-- coupling):
--   buf.lua   — buf_ls: registers buf workspace/config filetypes via `setup`
--   lua.lua   — lua_ls: LuaJIT runtime and vim / luv workspace libraries
--   ocaml.lua — ocamllsp: extra inlay-hint / codelens settings
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  lazy = false,

  -- Diagnostic / code-action mappings. Handlers are vim.lsp / vim.diagnostic
  -- builtins, but they're useless without the LSP this slice starts, so they
  -- belong here — removing this slice removes them too.
  keys = {
    {
      "<leader>qf",
      function()
        vim.lsp.buf.code_action()
      end,
      desc = "Quick fix",
    },
    {
      "<leader>f",
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      desc = "Floating diagnostic",
    },
    {
      "gK",
      function()
        vim.lsp.buf.signature_help()
      end,
      desc = "Signature help",
    },
  },

  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    local severity = vim.diagnostic.severity
    vim.diagnostic.config {
      virtual_text = { prefix = "" },
      signs = {
        text = {
          [severity.ERROR] = "󰅙",
          [severity.WARN] = "",
          [severity.INFO] = "󰋼",
          [severity.HINT] = "󰌵",
        },
      },
      underline = true,
      float = { border = "single" },
    }

    -- base46's treesitter colors and LSP semantic tokens paint the same
    -- captures. Keep tokens off so the theme stays the one source of color.
    vim.lsp.config("*", {
      on_init = function(client, _)
        if client:supports_method "textDocument/semanticTokens" then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    -- The registry. Simple servers are `name = {}`; servers with their own
    -- file pull their entry in by key so the full server list stays readable
    -- here in one place.
    local servers = {
      html = {},
      cssls = {},
      jsonls = {},
      lua_ls = require "plugins.lspconfig.lua",
      clangd = {},
      rust_analyzer = {},
      nixd = {},
      ocamllsp = require "plugins.lspconfig.ocaml",
      tombi = {},
      yamlls = {},
      marksman = {},
      r_language_server = {},
      basedpyright = {},
      gopls = {},
      jsonnet_ls = {},
      nushell = {},
      -- Protobuf / Buf workspace: `buf` ships its own LSP (`buf lsp serve`)
      buf_ls = require "plugins.lspconfig.buf",
      -- GitHub Copilot: drives native inline completion + sidekick.nvim NES.
      -- Needs `npm install -g @github/copilot-language-server`.
      copilot = require "plugins.lspconfig.copilot",
    }

    -- Buffer-local LSP jumps. These used to come from nvchad.configs.lspconfig.
    -- Kept: gd / gD / <leader>D — there is no Neovim default for them.
    -- Not carried over (no command-history evidence, and they are not part of
    -- daily editing): <leader>wa / <leader>wr / <leader>wl (workspace folders)
    -- and <leader>ra (NvChad renamer). Rename is Neovim's `grn`, which prompts
    -- through snacks' vim.ui.input.
    local on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = desc }
      end

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

      -- https://github.com/mrcjkb/rustaceanvim/discussions/46#discussioncomment-7636177
      -- https://gist.github.com/Chattille/adbd1f296b03bc3f85bb7f8d6f648c6f
      vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end,
      })
      -- Trigger an initial refresh manually.
      vim.lsp.inlay_hint.enable(true)
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    -- Single registration pass: run each entry's optional `setup` wiring, then
    -- merge the shared on_attach with the entry's opts and register the server.
    -- The merge copies into a fresh table so `servers` is never mutated — it
    -- stays pure data, and `setup` (registry-only) never leaks into the opts
    -- handed to vim.lsp.config.
    for name, entry in pairs(servers) do
      if entry.setup then
        entry.setup()
      end

      local opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, entry)
      opts.setup = nil

      vim.lsp.config(name, opts)
    end

    vim.lsp.enable(vim.tbl_keys(servers), true)
  end,
}
