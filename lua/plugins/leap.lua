---@type LazySpec
return {
  "andyg/leap.nvim",
  -- The short name is not where this is installed from.
  url = "https://codeberg.org/andyg/leap.nvim",
  lazy = false,

  -- Empty: show labels, never auto-jump.
  opts = {
    labels = "sfjklqeioawrndctuyuighthpxzmb",
    safe_labels = "",
  },

  keys = {
    { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
    { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
    { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
  },
}
