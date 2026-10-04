# Feature slices

Where a feature slice, a mapping, or startup config lives.
Names are defined in [CONTEXT.md](../CONTEXT.md).

## Feature slice

A feature slice carries its declaration, its configuration, and the mappings it owns. Removing the slice removes the feature.

Split a slice into a directory when a part already wants to live on its own. A `require` between those files uses the full module path from `lua/`.

Giving a slice `keys` lazy-loads it. A slice that must load at startup sets `lazy = false`.

## Mappings

A plugin mapping we invoke lives in `keys`. `:Lazy unload` unmaps `keys` only.

A key the plugin's own state machine consumes lives in that plugin's keymap option, on the same slice.

A mapping whose lifetime is the buffer is set where the `bufnr` is available.

An editor-global mapping lives in `mappings.lua`.

A mapping that calls a builtin belongs to the slice when removing the slice would leave the mapping with nothing useful to do.

A mapping for a module that ships inside another slice lives on that slice.

## Startup config

Plugin configuration stays on the slice. `configs/` holds startup config outside any plugin's options. Feature behavior lives on a slice; `init.lua` is bootstrap.

Neovim options live in `options.lua`. base46 theme config lives in `chadrc.lua`, the name nvchad/ui reads.
