---@type LazySpec[]
return {
  {
    "romus204/tree-sitter-manager.nvim",
    branch = "develop",
    -- BufReadPost is too late for the first FileType, so highlighting waits for a later event.
    lazy = false,
    cmd = { "TSManager", "TSInstall", "TSUninstall", "TSUpdate" },
    opts = {
      auto_install = true,
      languages = {
        numbat = {
          install_info = {
            url = "https://github.com/Devin-Yeung/tree-sitter-numbat",
            -- Install the queries shipped in the grammar repo.
            use_repo_queries = true,
            queries = "queries",
          },
        },
      },
      ensure_installed = {
        "c",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
        "luadoc",
        "printf",
        "html",
        "css",
        "nix",
        "json",
        "toml",
        "rust",
        "jsonnet",
        -- .nbt is already filetype `numbat`.
        "numbat",
      },
    },
    config = function(_, opts)
      require("tree-sitter-manager").setup(opts)
    end,
  },
}
