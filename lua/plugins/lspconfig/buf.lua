-- buf.yaml and friends are not auto-detected, unlike .proto.
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
