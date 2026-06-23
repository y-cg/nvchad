-- OCaml LSP extra settings — inlay hints and codelens.
-- See: https://github.com/ocaml/ocaml-lsp/blob/master/ocaml-lsp-server/docs/ocamllsp/config.md
--
-- Returns the ocamllsp registry entry (pure data). The shared on_attach and
-- registration are applied by lua/plugins/lspconfig/init.lua's merge loop.
return {
  settings = {
    inlayHints = {
      enable = true,
    },
    codelens = {
      enable = true,
    },
  },
}
