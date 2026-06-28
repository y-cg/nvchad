-- GitHub Copilot LSP configuration
-- Prerequisite: npm install -g @github/copilot-language-server

local base_on_attach

return {
  setup = function()
    -- Capture the base on_attach to preserve :LspCopilotSignIn/Out commands
    local base = vim.lsp.config.copilot
    base_on_attach = base and base.on_attach
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
