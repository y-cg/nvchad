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
-- Picker mappings live in this slice's keys field below.

---@type LazySpec[]
return {
  -- Disable the Telescope spec pulled in by NvChad via `import = "nvchad.plugins"`.
  -- Its <leader>f* mappings are explicitly remapped or no-op'd in lua/mappings.lua.
  { "nvim-telescope/telescope.nvim", enabled = false },

  {
    "alexpasmantier/tv.nvim",

    keys = {
      {
        "<leader><leader>",
        function()
          require("tv").tv_channel "files"
        end,
        desc = "Find files (tv)",
      },
      {
        "<leader>ff",
        function()
          require("tv").tv_channel "files"
        end,
        desc = "Find files (tv)",
      },
      {
        "<leader>fa",
        function()
          require("tv").tv_channel "files"
        end,
        desc = "Find files (tv)",
      },
      {
        "<leader>fw",
        function()
          require("tv").tv_channel "text"
        end,
        desc = "Live grep (tv)",
      },
      {
        "<leader>cm",
        function()
          require("tv").tv_channel "git-log"
        end,
        desc = "Git commits (tv)",
      },
    },

    -- opts is a function because handlers need require("tv").handlers
    opts = function()
      local h = require("tv").handlers

      return {
        -- Landscape layout with a fullscreen floating window — width/height
        -- are ratios of the editor size (see tv.nvim/lua/tv/window.lua),
        -- so 1.0 makes the panel span the entire nvim screen (row/col land
        -- at 0,0). Rounded border kept as decoration; it draws outside the
        -- window geometry and does not shrink the usable area.
        layout = "landscape",
        window = { width = 1.0, height = 1.0, border = "rounded", title_pos = "center" },

        -- ----------------------------------------------------------------------
        -- Per-channel overrides
        -- ----------------------------------------------------------------------
        -- These MUST live under `channels = { ... }`: tv.nvim reads
        -- `config.current.channels[channel]` (see tv.nvim/lua/tv/config.lua,
        -- `get_channel_config` and `M.defaults`). Placing them at the top
        -- level silently no-ops — args/handlers never reach the tv binary,
        -- which is why `--preview-size 50` had no effect until now.
        channels = {
          -- ----------------------------------------------------------------------
          -- Channel: files — equivalent to Telescope find_files
          -- ----------------------------------------------------------------------
          -- <CR> opens in the current window; the rest carry over the behavior
          -- we had with Telescope: send to quickfix, horizontal/vertical split,
          -- copy path to system clipboard.
          files = {
            -- Split the picker 50/50 between the results list and the preview
            -- panel. `--preview-size` is the preview's share of the screen
            -- width in percent (1-99); the channel default is 70. The
            -- --no-remote / --no-status-bar flags are repeated because
            -- tv.nvim replaces the channel's args wholesale when this field
            -- is set.
            args = { "--no-remote", "--no-status-bar", "--preview-size", "50" },
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
        },
      }
    end,
  },
}
