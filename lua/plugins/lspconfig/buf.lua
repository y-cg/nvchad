-- buf_ls registry entry.
--
-- Returns the buf_ls entry (pure data). It carries no LSP opts; its only need
-- is filetype registration, expressed through the registry's `setup` thunk so
-- it runs once at registration time — regardless of whether buf_ls ever
-- attaches to a buffer. See lua/plugins/lspconfig/init.lua for the contract.
--
-- The `proto` filetype is built into Neovim so .proto files work out of the
-- box. buf.yaml and friends are not auto-detected; see:
-- https://github.com/bufbuild/buf/blob/main/cmd/buf-ls/README.md
return {
  setup = function()
    vim.filetype.add {
      filename = {
        ["buf.yaml"] = "buf-config",
        ["buf.gen.yaml"] = "buf-config",
        ["buf.policy.yaml"] = "buf-config",
        ["buf.lock"] = "buf-config",
      },
    }
  end,
}
