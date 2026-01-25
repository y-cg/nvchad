-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers =
  { "html", "cssls", "jsonls", "lua_ls", "clangd", "rust_analyzer", "pyright", "nixd", "ocamllsp", "tombi", "yamlls" }

local nvlsp = require "nvchad.configs.lspconfig"

local on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  -- https://github.com/mrcjkb/rustaceanvim/discussions/46#discussioncomment-7636177
  -- https://gist.github.com/Chattille/adbd1f296b03bc3f85bb7f8d6f648c6f
  vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
  -- manually call a refresh
  vim.lsp.inlay_hint.enable(true)
  vim.lsp.codelens.refresh()
end

-- lsps with default config
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
