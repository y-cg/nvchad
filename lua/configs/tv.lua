-- ==============================================================================
-- tv.nvim picker configuration
-- ==============================================================================
--
-- tv.nvim is a thin Neovim wrapper around the `tv` (television) binary. The
-- picker logic — file walking, ignore handling, sorters, previewers — lives in
-- the Rust binary; the Lua side just configures layout and dispatches the
-- selected result through a handler function.
--
-- That is why we do NOT carry over the old telescope customization that picked
-- a custom `find_command` (`rg --files --hidden --glob '!.git/*'`): there is
-- no Lua-level knob for it. If we ever need different ignore behaviour, the
-- place to change it is the `tv` binary's channel config, not this file.

local function opts()
  local h = require("tv").handlers

  return {
    -- The floating window sits at the bottom (landscape) with a rounded
    -- border — closest to NvChad's telescope layout.
    layout = "landscape",
    window = { border = "rounded", title_pos = "center" },

    -- --------------------------------------------------------------------------
    -- Channel: files
    -- --------------------------------------------------------------------------
    -- Equivalent of `Telescope find_files`. `<CR>` opens the entry as a file
    -- in the current window; the other keys mirror the rest of the picker
    -- behaviour we used from telescope: send to quickfix, split / vsplit,
    -- and copy the path to the system clipboard.
    files = {
      handlers = {
        ["<CR>"] = h.open_as_files,
        ["<C-q>"] = h.send_to_quickfix,
        ["<C-s>"] = h.open_in_split,
        ["<C-v>"] = h.open_in_vsplit,
        ["<C-y>"] = h.copy_to_clipboard,
      },
    },

    -- --------------------------------------------------------------------------
    -- Channel: text
    -- --------------------------------------------------------------------------
    -- Equivalent of `Telescope live_grep`. `open_at_line` jumps to the
    -- grep match's file:line; the rest mirrors the `files` channel.
    text = {
      handlers = {
        ["<CR>"] = h.open_at_line,
        ["<C-q>"] = h.send_to_quickfix,
        ["<C-x>"] = h.open_in_split,
        ["<C-v>"] = h.open_in_vsplit,
        ["<C-y>"] = h.copy_to_clipboard,
      },
    },

    -- --------------------------------------------------------------------------
    -- Channel: git-log
    -- --------------------------------------------------------------------------
    -- Equivalent of `Telescope git_commits`. tv has no built-in handler that
    -- does "show the diff for a commit in a buffer", so we open a tab with
    -- a terminal that runs `git show <hash>`. Lightweight on purpose — we
    -- can grow this into a real previewer later if we want.
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
end

return opts
