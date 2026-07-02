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
  --
  -- We must always hand on_dir() a non-nil path. vim.lsp defers the actual
  -- client start with vim.schedule (see vim/lsp.lua ~564), and by the time it
  -- runs the original bufnr may be gone — e.g. suda reopens a read-only file
  -- (a symlink into the nix store, which is read-only) as a fresh suda://
  -- buffer and wipes the original. If we return nil here, config.root_dir stays
  -- nil and vim.lsp.start() retries `vim.fs.root(bufnr, root_markers)` on the
  -- now-invalid bufnr, raising "Invalid buffer id". Fall back to the file's
  -- directory (or cwd) so root_dir is always set and that retry is skipped.
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

    -- Enable native ghost-text inline completion
    if client:supports_method("textDocument/inlineCompletion", bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
    end
  end,
}
