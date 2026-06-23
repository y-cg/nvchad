-- Register buf workspace/config file types.
-- The `proto` filetype is built into Neovim so .proto files work out of the
-- box. buf.yaml and friends are not auto-detected; see:
-- https://github.com/bufbuild/buf/blob/main/cmd/buf-ls/README.md
vim.filetype.add {
  filename = {
    ["buf.yaml"] = "buf-config",
    ["buf.gen.yaml"] = "buf-config",
    ["buf.policy.yaml"] = "buf-config",
    ["buf.lock"] = "buf-config",
  },
}
