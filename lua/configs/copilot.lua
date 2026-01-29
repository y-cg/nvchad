return {
  suggestion = {
    auto_trigger = true,
    keymap = {
      -- Let nvim-cmp handle <Tab> fallback/indent when no suggestion.
      -- Copilot accept is triggered from `lua/configs/cmp.lua` when visible.
      accept = false,
    },
  },
  panel = {
    enabled = true,
  },
  filetypes = {
    markdown = true,
  },
}
