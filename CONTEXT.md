# nvchad-dev

Personal Neovim configuration. The terms below are how features and mappings are named.

## Language

**Feature slice**:
One plugin feature, together with the configuration and mappings that belong to it.
_Avoid_: plugin spec, plugin module

**Plugin mapping**:
A mapping owned by a feature slice.
_Avoid_: plugin keymap

**Editor-global mapping**:
A mapping that no feature slice owns.
_Avoid_: general mapping, builtin mapping
