-- leap.nvim — jump to any visible position with two keystrokes.
-- Installed from the Codeberg mirror (`url` overrides the default GitHub source).
---@type LazySpec
return {
  "andyg/leap.nvim",
  url = "https://codeberg.org/andyg/leap.nvim",
  lazy = false,

  -- opts are small enough to inline (single-file slice convention — see CONTEXT.md).
  -- safe_labels = "": always show labels, never auto-jump — more predictable behavior.
  opts = {
    labels = "sfjklqeioawrndctuyuighthpxzmb",
    safe_labels = "",
  },

  -- s / S are leap-exclusive; they travel with the plugin.
  keys = {
    { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
    { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
  },
}
