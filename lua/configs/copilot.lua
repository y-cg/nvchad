return {
  suggestion = {
    auto_trigger = true,
    keymap = {
      -- Let blink.cmp handle <Tab> fallback/indent when no suggestion.
      -- Copilot accept is triggered from `lua/configs/blink.lua` when visible.
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
