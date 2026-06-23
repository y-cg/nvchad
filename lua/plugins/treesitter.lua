-- nvim-treesitter — syntax-tree-based highlighting / indentation / text objects
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
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

    -- Prefer the newer install API; fall back to ensure_installed if unavailable.
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and type(ts.install) == "function" then
      ts.install(parsers)
      opts.ensure_installed = nil
    else
      opts.ensure_installed = parsers
    end
  end,
}
