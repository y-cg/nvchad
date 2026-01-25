return function(_, opts)
  local parsers = {
    "vim",
    "lua",
    "vimdoc",
    "html",
    "css",
    "nix",
    "json",
    "toml",
    "rust",
  }

  -- Prefer new install API when available; fall back to ensure_installed.
  local ok, ts = pcall(require, "nvim-treesitter")
  if ok and type(ts.install) == "function" then
    ts.install(parsers)
    opts.ensure_installed = nil
  else
    opts.ensure_installed = parsers
  end
end
