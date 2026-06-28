-- sidekick.nvim — Copilot "Next Edit Suggestions" (NES) + an embedded AI CLI.
--
-- This replaces zbirenbaum/copilot.lua. Responsibilities are now split:
--   * as-you-type inline ghost text -> native LSP inline completion, served by
--     the copilot-language-server we register in lua/plugins/lspconfig (see
--     lua/plugins/lspconfig/copilot.lua)
--   * larger multi-line "next edit" diffs (NES) + an AI CLI terminal -> here
-- NES reads from that same attached Copilot client, so no server wiring is
-- needed in this slice.
--
-- <Tab> handling is split by mode, on purpose:
--   * insert mode -> chained inside blink.cmp (lua/plugins/blink.lua) so NES
--     cooperates with snippet jumps, the completion menu, and inline completion
--   * normal mode -> bound here; jump to / apply the pending NES, otherwise fall
--     through to the built-in <Tab> (jumplist forward)
---@type LazySpec
return {
  "folke/sidekick.nvim",
  -- Load early enough that NES autocmds are registered before we start editing,
  -- without paying the cost at startup. The Copilot LSP it consumes attaches on
  -- file open independently.
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
    -- The Copilot LSP reports "User not signed in" at ERROR level, which sidekick
    -- turns into a `:LspCopilotSignIn` notification (lua/sidekick/status.lua).
    -- We don't want that prompt nagging on every buffer when we haven't signed in,
    -- so raise the status threshold to OFF.
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
        -- Jump to the next edit, or apply it once we're on it. Returning the
        -- literal key lets the mapping fall through to the default normal-mode
        -- <Tab> (jumplist forward) when there is no pending suggestion.
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
