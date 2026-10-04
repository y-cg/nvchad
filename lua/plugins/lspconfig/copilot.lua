-- Prerequisite: npm install -g @github/copilot-language-server

local base_on_attach

-- oil sets `filetype=oil` before `buftype=acwrite`, so the usual
-- non-empty-buftype auto-attach guard never applies.
local excluded_filetypes = { "oil" }

return {
  setup = function()
    -- The default on_attach installs :LspCopilotSignIn / :LspCopilotSignOut.
    local base = vim.lsp.config.copilot
    base_on_attach = base and base.on_attach
  end,

  -- Always call on_dir. An unset root makes vim.lsp retry on the bufnr after
  -- suda may have wiped that buffer ("Invalid buffer id").
  root_dir = function(bufnr, on_dir)
    if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    local root = vim.fs.root(bufnr, { ".git" })
    if not root then
      local name = vim.api.nvim_buf_get_name(bufnr)
      root = (name ~= "" and vim.fs.dirname(name)) or vim.fn.getcwd()
    end
    on_dir(root)
  end,

  on_attach = function(client, bufnr)
    if base_on_attach then
      base_on_attach(client, bufnr)
    end

    if client:supports_method("textDocument/inlineCompletion", bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    end
  end,
}
