-- GitHub Copilot LSP configuration
-- Prerequisite: npm install -g @github/copilot-language-server

local base_on_attach

-- Copilot has no `filetypes` restriction, so it attaches to every filetype.
-- oil sets `filetype=oil` before `buftype=acwrite`, racing past nvim's
-- `buftype ~= ""` auto-attach guard — so we must exclude it ourselves.
-- TODO: add other non-code filetypes here as they come up.
local excluded_filetypes = { "oil" }

return {
  setup = function()
    -- Capture the base on_attach to preserve :LspCopilotSignIn/Out commands
    local base = vim.lsp.config.copilot
    base_on_attach = base and base.on_attach
  end,

  -- Skip excluded filetypes; otherwise attach (works in non-git dirs too,
  -- since copilot sets no `workspace_required`).
  root_dir = function(bufnr, on_dir)
    if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    on_dir(vim.fs.root(bufnr, { ".git" }))
  end,

  on_attach = function(client, bufnr)
    if base_on_attach then
      base_on_attach(client, bufnr)
    end

    -- Enable native ghost-text inline completion
    if client:supports_method("textDocument/inlineCompletion", bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    end
  end,
}
