-- copilot.lua — GitHub Copilot inline suggestions (<Tab> accept logic is
-- coordinated in the blink slice)
---@type LazySpec
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
      -- Copilot attaches to almost every buffer by default. When it attaches
      -- to an oil buffer, NvChad's global LspAttach autocmd fires and sets the
      -- buffer-local LSP keymaps (e.g. `gd` -> definition), which clobber
      -- oil's own `gd`/`go` navigation. Copilot has nothing to offer in a
      -- directory buffer, so disable it there.
      oil = false,
    },
  },
}
