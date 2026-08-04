-- kulala.nvim — HTTP/GraphQL/gRPC/WebSocket client for JetBrains .http files.
-- Lazy-loaded on .http/.rest buffers or the scratchpad/send keymaps below.
-- Needs Neovim 0.12+, curl, git, and tree-sitter-cli (all present here).
-- Kulala manages its own treesitter parser/queries and downloads kulala-core.
---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  -- Register session hooks so request history can restore after :source Session.
  event = { "SessionLoadPost", "VimLeavePre" },
  ft = { "http", "rest" },
  keys = {
    -- Prefer <CR> in .http buffers (no leader chord). Leader maps use `k`
    -- (kulala), not `r` — a failed `<leader>r…` chord falls through to
    -- normal-mode `r` (replace-char), which feels like substitute.
    {
      "<CR>",
      function()
        require("kulala").run()
      end,
      mode = { "n", "v" },
      ft = { "http", "rest" },
      desc = "Send request",
    },
    {
      "<leader>ks",
      function()
        require("kulala").run()
      end,
      mode = { "n", "v" },
      desc = "Send request",
    },
    {
      "<leader>ka",
      function()
        require("kulala").run_all()
      end,
      mode = { "n", "v" },
      desc = "Send all requests",
    },
    {
      "<leader>kr",
      function()
        require("kulala").replay()
      end,
      desc = "Replay last request",
    },
    {
      "<leader>kb",
      function()
        require("kulala").scratchpad()
      end,
      desc = "Open scratchpad",
    },
    {
      "<leader>ke",
      function()
        require("kulala").set_selected_env()
      end,
      ft = { "http", "rest" },
      desc = "Select environment",
    },
    {
      "<leader>kc",
      function()
        require("kulala").copy()
      end,
      ft = { "http", "rest" },
      desc = "Copy as cURL",
    },
  },
  init = function()
    -- Neovim does not map .http → filetype=http by default; without this,
    -- `ft = { "http" }` never fires and highlighting/LSP stay off.
    vim.filetype.add {
      extension = {
        http = "http",
      },
    }
  end,
  opts = {
    -- Keymaps live in `keys` above (slice ownership / lazy unload). Keep
    -- kulala's own global set off so we don't double-bind <leader>k*.
    global_keymaps = false,
    ui = {
      -- Kulala forces indent folding on its response window. Keep response
      -- folds available, but show them expanded when the window opens.
      win_opts = {
        wo = {
          foldlevel = 99,
        },
      },
    },
    -- Let the general window-navigation mappings own <C-h>/<C-l> even in
    -- Kulala's UI buffer. `false` removes Kulala's buffer-local tab bindings
    -- instead of shadowing the global mappings with <Nop>.
    kulala_keymaps = {
      ["Previous tab"] = false,
      ["Next tab"] = false,
      ["Show verbose"] = {
        "<leader>kv",
        function()
          require("kulala.ui").show_verbose()
        end,
        mode = { "n" },
      },
    },
  },
}
