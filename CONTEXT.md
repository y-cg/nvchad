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

**When to promote to a directory**: don't go by line count — ask whether a
second file is genuinely needed. A slice that's grown to the point where
extracting a part into its own file *concentrates* complexity warrants a
directory. Merely being long (e.g. the current `lspconfig`, `tv`, `blink`)
while remaining a single cohesive config block does not — forced splitting
*scatters* complexity and fails the delete test.

A directory is an **escape hatch**; no plugin currently needs one.

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
  with the plugin and double as lazy-load triggers).
- **Editor-global mappings → stay in `lua/mappings.lua`**: general mappings not
  owned by any single plugin — e.g. `jk`→ESC, `;`→`:`, buffer cycling, and
  mappings for builtins like `vim.lsp`/`vim.diagnostic` (no plugin slice to
  attach them to).

Decision rule: is this mapping specific to one plugin, or general enough to
stand alone? General → `mappings.lua`.

### Exception: NvChad default overrides must stay in mappings.lua

There is a hard load-order rule: `init.lua` uses `vim.schedule` to
`require "mappings"` at the very end of startup, and `mappings.lua` calls
`require "nvchad.mappings"` on its first line. This means **NvChad's default
mappings are registered last** and will overwrite any same-lhs mapping
registered earlier.

lazy's slice `keys` are registered early (during `lazy.setup`), so any mapping
whose lhs **collides with a NvChad default** placed in a slice `keys` will be
overwritten back to the default when `nvchad.mappings` runs.

Conclusion:
- **Mappings that collide with NvChad defaults** (e.g. picker `<leader>ff/fa/fw/cm`,
  format `<leader>fm`) → must live in `mappings.lua`, set **after**
  `require "nvchad.mappings"`.
- **Plugin-specific mappings that don't collide** (e.g. leap's `s`/`S`,
  neogit's `<leader>gg`) → go in their slice's `keys` field as normal.

To check whether a mapping collides: inspect
`~/.local/share/nvim/lazy/NvChad/lua/nvchad/mappings.lua`.

## Directory responsibilities

- **`lua/plugins/`** — feature slices; one file (or directory) per feature.
- **`lua/configs/`** — **startup-time config** that is not a plugin's opts,
  e.g. `lazy.lua` (lazy.nvim's own settings) and `neovide.lua` (GUI
  integration). Plugin opts always go in their slice.
- **`init.lua`** — pure bootstrap: leader/base46 cache, lazy clone,
  `lazy.setup`, theme load, entry-module requires. No concrete feature logic
  (features go in slices; GUI goes in `configs/`).
- **`lua/mappings.lua`** — editor-global mappings.
- **`lua/options.lua`** / `lua/chadrc.lua` — Neovim options / NvChad theme
  configuration.

## Load semantics

Restructuring does not change load timing. Plugins that need `lazy = false`
(load at startup) keep that setting. Startup-time optimization is separate,
follow-on work and should not be mixed with structural reorganization.
