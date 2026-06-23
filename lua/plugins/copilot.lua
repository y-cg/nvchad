-- copilot.lua — GitHub Copilot inline suggestions (<Tab> accept logic is
-- coordinated in the blink slice)
return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        -- When no suggestion is visible, let blink.cmp handle <Tab>
        -- fallback/indent. The actual "accept" when a suggestion IS visible
        -- is triggered from lua/plugins/blink.lua.
        accept = false,
      },
    },
    panel = {
      enabled = true,
    },
    filetypes = {
      markdown = true,
    },
  },
}
