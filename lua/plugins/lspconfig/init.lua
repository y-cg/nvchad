---@type LazySpec
return {
  "neovim/nvim-lspconfig",
  -- A `keys` field would lazy-load this spec, so servers would not start when a file opens.
  lazy = false,

  keys = {
    {
      "<leader>qf",
      function()
        vim.lsp.buf.code_action()
      end,
      desc = "Quick fix",
    },
    {
      "<leader>f",
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      desc = "Floating diagnostic",
    },
    {
      "gK",
      function()
        vim.lsp.buf.signature_help()
      end,
      desc = "Signature help",
    },
  },

  config = function()
    dofile(vim.g.base46_cache .. "lsp")

    local severity = vim.diagnostic.severity
    vim.diagnostic.config {
      virtual_text = { prefix = "" },
      signs = {
        text = {
          [severity.ERROR] = "󰅙",
          [severity.WARN] = "",
          [severity.INFO] = "󰋼",
          [severity.HINT] = "󰌵",
        },
      },
      underline = true,
      float = { border = "single" },
    }

    -- base46 and semantic tokens color the same captures.
    vim.lsp.config("*", {
      on_init = function(client, _)
        if client:supports_method "textDocument/semanticTokens" then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    local servers = {
      html = {},
      cssls = {},
      jsonls = {},
      lua_ls = require "plugins.lspconfig.lua",
      clangd = {},
      rust_analyzer = {},
      nixd = {},
      ocamllsp = require "plugins.lspconfig.ocaml",
      tombi = {},
      yamlls = {},
      marksman = {},
      r_language_server = {},
      basedpyright = {},
      gopls = {},
      jsonnet_ls = {},
      nushell = {},
      buf_ls = require "plugins.lspconfig.buf",
      copilot = require "plugins.lspconfig.copilot",
    }

    local on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = desc }
      end

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

      -- https://github.com/mrcjkb/rustaceanvim/discussions/46#discussioncomment-7636177
      -- https://gist.github.com/Chattille/adbd1f296b03bc3f85bb7f8d6f648c6f
      vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end,
      })
      vim.lsp.inlay_hint.enable(true)
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    for name, entry in pairs(servers) do
      if entry.setup then
        entry.setup()
      end

      local opts = vim.tbl_deep_extend("force", { on_attach = on_attach }, entry)
      opts.setup = nil -- not an LSP option

      vim.lsp.config(name, opts)
    end

    vim.lsp.enable(vim.tbl_keys(servers), true)
  end,
}
