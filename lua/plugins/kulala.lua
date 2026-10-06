---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  -- History is restored from these session hooks.
  event = { "SessionLoadPost", "VimLeavePre" },
  ft = { "http", "rest" },
  keys = {
    -- A failed `<leader>r…` chord falls through to `r` (replace character).
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
    -- .http is not a default filetype, so `ft = "http"` would never match.
    vim.filetype.add {
      extension = {
        http = "http",
      },
    }
  end,
  opts = {
    -- Maps live in `keys`; kulala's own set would bind them again.
    global_keymaps = false,
    ui = {
      -- The response window opens with indent folds; start them expanded.
      win_opts = {
        wo = {
          foldlevel = 99,
        },
      },
    },
    -- `<C-h>` / `<C-l>` belong to window navigation. `false` removes the binding
    -- instead of shadowing it with <Nop>.
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
