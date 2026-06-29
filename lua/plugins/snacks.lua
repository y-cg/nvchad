-- ==============================================================================
-- snacks.nvim — vim.ui.select / vim.ui.input backend (replaces dressing.nvim)
-- ==============================================================================
--
-- Scope: ONLY provide a pretty floating backend for `vim.ui.select` and
-- `vim.ui.input`. We intentionally enable just two snacks modules — `picker`
-- (as the ui.select backend) and `input` (as the ui.input backend) — and leave
-- every other snacks feature off. In particular:
--   * file/grep picking stays with tv.nvim (lua/plugins/tv.lua). tv is invoked
--     through its own keymaps, never via `vim.ui.select`, so the two don't
--     collide. snacks.picker only fires when some plugin calls
--     `vim.ui.select` (or `Snacks.picker` directly, which we never do).
--   * completion stays with blink.cmp; snacks is not a completion source here.
--   * the notifier / statuscolumn / explorer / etc. modules are deliberately
--     disabled to avoid surprising UI takeovers.
--
-- The motivating caller is sidekick.nvim's CLI tool picker
-- (`lua/sidekick/cli/ui/select.lua`): it issues
-- `vim.ui.select(..., { kind = "sidekick_cli", snacks = { format = M.format } })`.
-- Because snacks is the registered ui.select backend, that `snacks.format`
-- field is honored — sidekick supplies per-item highlights (status icon, the
-- `[backend:session]` tag, the cwd path) that dressing's plain-text
-- `format_item` could not render. This is the supported combo: sidekick's
-- default `opts.cli.picker` is `"snacks"` and it ships a matching
-- `lua/sidekick/cli/picker/snacks.lua`.
--
-- Why not television (tv.nvim) here? tv is channel-based and ships no
-- `vim.ui.select` implementation, so it cannot back this prompt.
--
-- TODO: snacks.picker.ui_select accepts per-kind config
-- (`ui_select = { kinds = { sidekick_cli = { layout = {...} } } }`). If we want
-- the sidekick tool list on a bespoke layout (e.g. a wider vertical split to
-- fit the cwd column), wire it here instead of relying on the default
-- `select` preset.

---@type LazySpec
return {
  "folke/snacks.nvim",
  -- Load alongside sidekick (VeryLazy) so the ui.select override is installed
  -- before any picker is opened, without paying for it at startup.
  event = "VeryLazy",

  --@param opts table snacks will deep-extend these with its own defaults.
  opts = {
    -- Pretty floating `vim.ui.select`. `ui_select = true` registers
    -- `Snacks.picker.select` as the global `vim.ui.select` backend, so every
    -- plugin's select prompt (sidekick, LSP code-action, conform formatter
    -- choice, etc.) gets the same treatment — that's the point.
    picker = {
      enabled = true,
      ui_select = true,
      -- Keep the default `select` preset; sidekick's custom format is applied
      -- per-item via the `snacks.format` opt it passes, independent of layout.
    },

    -- Pretty floating `vim.ui.input` (rename prompts, etc.). NvChad ships no
    -- input override and blink.cmp doesn't touch `vim.ui.input`, so this is a
    -- safe, strictly-better swap.
    input = {
      enabled = true,
    },
  },
}
