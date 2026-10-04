-- lua_ls registry entry — Neovim's LuaJIT runtime and the vim / luv libraries.
-- Without these, lua-language-server treats this config as stock Lua and
-- misses `vim.*` plus the luv API.
--
-- Returns the lua_ls registry entry (pure data). The shared on_attach and
-- registration are applied by lua/plugins/lspconfig/init.lua's merge loop.
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          "${3rd}/luv/library",
        },
      },
    },
  },
}
