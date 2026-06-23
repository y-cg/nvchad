-- nvim-lspconfig — LSP server registration and per-buffer on_attach behavior
--
-- Note: global diagnostic/code-action mappings (<leader>f <leader>qf) are NOT
-- here — they go through vim.diagnostic / vim.lsp builtins and don't belong to
-- any single plugin, so they live in lua/mappings.lua.
return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Load NvChad defaults (lua_ls, etc.)
    require("nvchad.configs.lspconfig").defaults()

    -- blink.cmp normally reports LSP capabilities on its own, but with
    -- Neovim 0.11+ and `vim.lsp.config`, upstream docs allow skipping that
    -- extra wiring.
    -- TODO: revisit if we stop using `vim.lsp.config`

    -- Register the `buf-config` filetype for buf workspace/config files.
    -- The `proto` filetype is built into Neovim so .proto files work out of
    -- the box. buf.yaml etc. are not auto-detected; see:
    -- https://github.com/bufbuild/buf/blob/main/cmd/buf-ls/README.md
    vim.filetype.add {
      filename = {
        ["buf.yaml"] = "buf-config",
        ["buf.gen.yaml"] = "buf-config",
        ["buf.policy.yaml"] = "buf-config",
        ["buf.lock"] = "buf-config",
      },
    }

    local servers = {
      "html",
      "cssls",
      "jsonls",
      "lua_ls",
      "clangd",
      "rust_analyzer",
      "nixd",
      "ocamllsp",
      "tombi",
      "yamlls",
      "marksman",
      "r_language_server",
      "basedpyright",
      "gopls",
      -- Protobuf / Buf workspace: `buf` ships its own LSP (`buf lsp serve`)
      "buf_ls",
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

    -- Register all servers with the shared on_attach.
    for _, lsp in ipairs(servers) do
      vim.lsp.config(lsp, {
        on_attach = on_attach,
      })
    end

    vim.lsp.config("ocamllsp", {
      -- See: https://github.com/ocaml/ocaml-lsp/blob/master/ocaml-lsp-server/docs/ocamllsp/config.md
      settings = {
        inlayHints = {
          enable = true,
        },
        codelens = {
          enable = true,
        },
      },
    })

    vim.lsp.enable(servers, true)
  end,
}
