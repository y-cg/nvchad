-- ==============================================================================
-- Neovide GUI integration
-- ==============================================================================
--
-- Only runs inside the Neovide GUI frontend (terminal nvim never reaches this
-- file — see the `if vim.g.neovide` guard in init.lua). Collects all
-- GUI-related behavior: macOS-style copy/paste mappings and window opacity.
--
-- This is a "startup-time" variant of a feature slice: it's not a plugin but
-- a GUI environment integration, so it lives in configs/ rather than plugins/
-- (see CONTEXT.md). Add new GUI tweaks here instead of back in init.lua.

-- ------------------------------------------------------------------------------
-- Copy / Paste
-- ------------------------------------------------------------------------------
-- Neovide runs as a system GUI, so macOS <D-...> (Cmd) chords are available.
-- Bridge them to the system clipboard (`+` register) so Cmd-S/C/V feel native.
local function save()
  vim.cmd.write()
end

local function copy()
  vim.cmd [[normal! "+y]]
end

local function paste()
  vim.api.nvim_paste(vim.fn.getreg "+", true, -1)
end

vim.keymap.set({ "n", "i", "v" }, "<D-s>", save, { desc = "Save" })
vim.keymap.set("v", "<D-c>", copy, { silent = true, desc = "Copy" })
vim.keymap.set({ "n", "i", "v", "c", "t" }, "<D-v>", paste, { silent = true, desc = "Paste" })

-- ------------------------------------------------------------------------------
-- Opacity
-- ------------------------------------------------------------------------------
vim.g.neovide_opacity = 0.8
vim.g.neovide_normal_opacity = 0.8
