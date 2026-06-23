-- OCaml LSP extra settings — inlay hints and codelens.
-- See: https://github.com/ocaml/ocaml-lsp/blob/master/ocaml-lsp-server/docs/ocamllsp/config.md
vim.lsp.config("ocamllsp", {
  settings = {
    inlayHints = {
      enable = true,
    },
    codelens = {
      enable = true,
    },
  },
})
