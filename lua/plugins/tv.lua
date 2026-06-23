-- ==============================================================================
-- tv.nvim — picker (replaces Telescope)
-- ==============================================================================
--
-- tv.nvim is a thin wrapper around the `tv` (television) binary. The real
-- picker logic — file traversal, ignore handling, sorting, preview — all lives
-- in the Rust binary. The Lua side only configures layout and dispatches
-- selected entries to handler functions.
--
-- This slice also disables Telescope: "switch to tv" and "drop telescope" are
-- two halves of the same decision, kept together so a future picker swap is
-- visible in one place.
--
-- Picker mappings (<leader>ff/fa/fw/cm/<leader><leader>) are NOT in this file:
-- they override NvChad's same-named telescope mappings and must take effect
-- after `require "nvchad.mappings"`, so they live in lua/mappings.lua
-- (load-order constraint — see CONTEXT.md).

return {
  -- Disable the Telescope spec pulled in by NvChad via `import = "nvchad.plugins"`.
  -- Its <leader>f* mappings are explicitly remapped or no-op'd in lua/mappings.lua.
  { "nvim-telescope/telescope.nvim", enabled = false },

  {
    "alexpasmantier/tv.nvim",

    -- opts is a function because handlers need require("tv").handlers
    opts = function()
      local h = require("tv").handlers

      return {
        -- Bottom-anchored floating window (landscape), rounded border —
        -- closest to NvChad's default Telescope layout.
        layout = "landscape",
        window = { border = "rounded", title_pos = "center" },

        -- ----------------------------------------------------------------------
        -- Channel: files — equivalent to Telescope find_files
        -- ----------------------------------------------------------------------
        -- <CR> opens in the current window; the rest carry over the behavior
        -- we had with Telescope: send to quickfix, horizontal/vertical split,
        -- copy path to system clipboard.
        files = {
          handlers = {
            ["<CR>"] = h.open_as_files,
            ["<C-q>"] = h.send_to_quickfix,
            ["<C-s>"] = h.open_in_split,
            ["<C-v>"] = h.open_in_vsplit,
            ["<C-y>"] = h.copy_to_clipboard,
          },
        },

        -- ----------------------------------------------------------------------
        -- Channel: text — equivalent to Telescope live_grep
        -- ----------------------------------------------------------------------
        -- open_at_line jumps to the file:line of the grep match; the rest
        -- mirrors the files channel.
        text = {
          handlers = {
            ["<CR>"] = h.open_at_line,
            ["<C-q>"] = h.send_to_quickfix,
            ["<C-x>"] = h.open_in_split,
            ["<C-v>"] = h.open_in_vsplit,
            ["<C-y>"] = h.copy_to_clipboard,
          },
        },

        -- ----------------------------------------------------------------------
        -- Channel: git-log — equivalent to Telescope git_commits
        -- ----------------------------------------------------------------------
        -- tv has no built-in handler to show a commit diff in a buffer, so we
        -- open a new tab running `git show <hash>` in a terminal. Intentionally
        -- lightweight — can be grown into a real previewer later.
        ["git-log"] = {
          handlers = {
            ["<CR>"] = function(entries)
              if entries[1] then
                vim.cmd("tabnew | terminal git show " .. vim.fn.shellescape(entries[1]))
              end
            end,
            ["<C-y>"] = h.copy_to_clipboard,
          },
        },
      }
    end,
  },
}
