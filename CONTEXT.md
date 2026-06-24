# nvchad-dev — configuration glossary (CONTEXT.md)

This config is built on NvChad v2.5. The terms below form its domain language.
Use them consistently so future readers (and your future self) share the same
vocabulary.

## Feature slice

A **feature slice** is the single canonical home for one plugin feature. It
collapses three things that would otherwise be scattered:

- **spec** — the lazy.nvim plugin declaration
- **opts** — the plugin's configuration
- **keys** — mappings owned by this plugin (via lazy's `keys` field)

Each slice lives under `lua/plugins/`. lazy.nvim's `{ import = "plugins" }`
auto-loads every module in that directory, so **the directory itself is the
registry** — adding a feature means creating a file in `plugins/`, with no
central list to update.

**Delete test**: remove a slice file and the feature should disappear cleanly.
If remnants survive (stray mappings, opts elsewhere), it wasn't truly a slice.

### Single file vs. directory

- **Small plugin → single file**: `lua/plugins/oil.lua` returns the full spec
  with opts inlined.
- **Large plugin → directory**: `lua/plugins/<name>/init.lua` returns the spec;
  sibling files hold private implementation details.

**When to promote to a directory**: don't go by line count — go by feel. If a
slice has become hard to maintain, or it's obvious a part wants to live on its
own, just split it. Don't overthink the bar.

`lspconfig` is the one directory in the tree: its per-server entries
(`buf.lua`, `ocaml.lua`) are independently meaningful pure-data modules that
clearly belonged in their own files. `tv` and `blink` are long but stay single
files because each is one cohesive config block with nothing crying out to be
extracted. When in doubt, leave it one file — a premature split scatters
complexity and fails the delete test.

### Cross-file references inside a directory

Lua/Neovim has no relative imports. Sibling files reference each other with
**dot-separated full paths** rooted at `lua/`:

```lua
-- lua/plugins/lspconfig/init.lua  (hypothetical example)
local servers = require("plugins.lspconfig.servers")  -- = lua/plugins/lspconfig/servers.lua
```

`.` is the path separator. When you move a file inside a directory, update all
`require` paths that reference it.

## Mapping ownership

- **Plugin-specific mappings → go in the slice's `keys` field** (they travel
  with the plugin; for a lazy-loaded slice they also double as load triggers).
  This is the *only* mechanism that lazy.nvim unmaps on `:Lazy unload`, so a
  mapping owned by a plugin MUST live in its `keys` field — never as a
  `vim.keymap.set` inside a `config` function, which would survive the plugin
  being unloaded. Note: adding `keys` to a slice makes it lazy by default —
  if the plugin must load at startup, set `lazy = false` explicitly (see
  `lspconfig`).
  **Exception: buffer-local mappings** (e.g. LSP jump keys set in `on_attach`
  with `{ buffer = bufnr }`). Their lifecycle is the buffer, not the plugin, so
  the unload rule does not apply — they may be set inside an `on_attach`-style
  hook that holds the `bufnr`, and only there.
- **Editor-global mappings → stay in `lua/mappings.lua`**: general mappings not
  owned by any single plugin — e.g. `jk`→ESC, `;`→`:`, window navigation, save,
  clear-search.

Decision rule: is this mapping specific to one plugin, or general enough to
stand alone? General → `mappings.lua`.

### `keys` field vs `opts.keymap`

Both travel with the plugin, but they are not interchangeable — pick by
*who consumes the key*:

- **`keys` field** — the handler is something *we* invoke: a plugin command or
  function we trigger from the outside (e.g. `conform.format` on `<leader>fm`,
  `leap.leap` on `s`, `neogit.open` on `<leader>gg`). lazy owns the lifecycle
  and unmaps on unload.
- **`opts.keymap`** — the key is *consumed by the plugin's own state machine*,
  where routing it through `keys` would bypass internal logic (e.g. blink's
  `<Tab>`/`<CR>` accept/reject coordination, copilot's suggestion trigger). The
  plugin reads and sets these itself; we only feed it config.

Test: does the key fire a plugin API we call, or does the plugin intercept the
key itself? Former → `keys`; latter → `opts.keymap`.

### Mappings for a plugin bundled inside another

Some plugins ship bundled inside a parent with no standalone lazy spec (e.g.
NvChad bundles tabufline and Comment). Their mappings live in the **parent
slice's `keys`** (here `nvchad.lua`), grouped under a labelled section. This
passes the delete test: removing the parent removes the bundled component and
its keys together.

Promote to a dedicated slice only when a bundled component's key count grows
enough to hurt the parent file's readability — not by line count alone.

### Mappings that call a builtin API but only matter under a plugin

Some mappings call a Neovim builtin (`vim.lsp.buf.*`, `vim.diagnostic.*`) that
is useless without the plugin that actually drives it. The test is: *if I
removed this slice, would the mapping still do something useful?* If not, the
mapping belongs to that slice's `keys` even though the API itself is a builtin.

- `<leader>qf` (`vim.lsp.buf.code_action`) and `<leader>f`
  (`vim.diagnostic.open_float`) live in the **lspconfig** slice's `keys`, not
  `mappings.lua`. This repo's only path to a working LSP is the lspconfig
  slice; removing it should take the mappings with it.

## Directory responsibilities

- **`lua/plugins/`** — feature slices; one file (or directory) per feature.
- **`lua/configs/`** — **startup-time config** that is not a plugin's opts,
  e.g. `lazy.lua` (lazy.nvim's own settings) and `neovide.lua` (GUI
  integration). Plugin opts always go in their slice.
- **`init.lua`** — pure bootstrap: leader/base46 cache, lazy clone,
  `lazy.setup`, theme load, entry-module requires. No concrete feature logic
  (features go in slices; GUI goes in `configs/`).
- **`lua/mappings.lua`** — editor-global mappings. This file deliberately does
  **not** `require "nvchad.mappings"`: we keep only the small subset of general
  mappings we actually use (window navigation, save, `jk`→ESC, `;`→`:`), rather
  than inheriting NvChad's full default set. Plugin-specific mappings live in
  their slice's `keys` (see "Mapping ownership" above); add a general mapping
  here only when no single plugin owns it.
- **`lua/options.lua`** / `lua/chadrc.lua` — Neovim options / NvChad theme
  configuration.

## Load semantics

Restructuring does not change load timing. Plugins that need `lazy = false`
(load at startup) keep that setting. Startup-time optimization is separate,
follow-on work and should not be mixed with structural reorganization.
