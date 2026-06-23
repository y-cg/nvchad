-- nvim-lspconfig — LSP server registration and per-buffer on_attach behavior
--
-- Capabilities: blink.cmp registers its own LSP capabilities when using
-- `vim.lsp.config` (Neovim 0.11+), so no explicit `capabilities` wiring is
-- needed here. TODO: revisit if we stop using `vim.lsp.config`.
--
-- Global diagnostic/code-action mappings (<leader>f, <leader>qf) go through
-- vim.diagnostic / vim.lsp builtins and don't belong to any single plugin,
-- so they live in lua/mappings.lua.
--
-- Server registry shape: `servers` is a name → entry table, the single source
-- of truth for both registration and `vim.lsp.enable`. Each entry holds the
-- opts merged into `vim.lsp.config`, plus one reserved key:
--   * setup — optional thunk run ONCE at registration time, before enable.
--             Use it for wiring a server needs that isn't LSP opts (e.g.
--             buf_ls registers its config filetypes). Defaults to absent = no-op.
-- Everything else in an entry is forwarded to `vim.lsp.config` verbatim.
--
-- Language-specific entries that are large enough to warrant their own file
-- live in siblings that RETURN their entry (pure data, no side effects, no
-- require-order coupling):
--   buf.lua   — buf_ls: registers buf workspace/config filetypes via `setup`
--   ocaml.lua — ocamllsp: extra inlay-hint / codelens settings
---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Load NvChad defaults (lua_ls, etc.)
    require("nvchad.configs.lspconfig").defaults()

    -- The registry. Simple servers are `name = {}`; servers with their own
    -- file pull their entry in by key so the full server list stays readable
    -- here in one place.
    local servers = {
      html = {},
      cssls = {},
      jsonls = {},
      lua_ls = {},
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
      -- Protobuf / Buf workspace: `buf` ships its own LSP (`buf lsp serve`)
      buf_ls = require "plugins.lspconfig.buf",
    }

    local nvlsp = require "nvchad.configs.lspconfig"

    local on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
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
