---@type LazySpec
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    nes = {
      ---@type boolean|fun(buf:integer):boolean?
      enabled = true,
    },
    ---@class sidekick.cli.Mux
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    -- "User not signed in" is reported at ERROR and would notify on every buffer.
    copilot = {
      status = {
        level = vim.log.levels.OFF,
      },
    },
  },
  keys = {
    {
      "<Tab>",
      function()
        -- Returning the key falls through to jumplist-forward when nothing is pending.
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Sidekick: goto/apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick: focus CLI",
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      mode = { "n", "x" },
      desc = "Sidekick: toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      mode = { "n", "x" },
      desc = "Sidekick: select CLI",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick: insert prompt",
    },
  },
}
