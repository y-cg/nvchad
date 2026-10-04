local map = vim.keymap.set

-- ============================================================================
-- General editor mappings
-- ============================================================================
-- Mappings not owned by any plugin slice: builtins, editor habits (jk, ;),
-- window navigation, and the built-in comment operator.

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

map("n", "<Esc>", function()
  -- `docs.hide` also closes noice's separate border window.
  local ok, docs = pcall(require, "noice.lsp.docs")
  if ok and docs._messages then
    for _, kind in ipairs { "hover", "signature" } do
      local msg = docs._messages[kind]
      if msg and msg:win() then
        docs.hide(msg)
      end
    end
  end

  if vim.api.nvim_mcursor ~= nil then
    local ns = vim.api.nvim_create_namespace "nvim.multicursor"
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end
  vim.cmd "nohlsearch"
end, { desc = "Close LSP docs, clear search highlights and multicursors" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Neovim's built-in comment operator. Previously mapped in the NvChad slice.
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("x", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ============================================================================
-- Multicursor (Neovim 0.13+ native multicursor)
-- ============================================================================
-- - In Normal mode: <C-n> marks current word and jumps to next match (Q* / Qn)
-- - In Visual mode: <C-n> places a cursor on every selected line ({Visual}Q)

map("n", "<C-n>", function()
  local ns = vim.api.nvim_create_namespace "nvim.multicursor"
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
  if #marks > 0 then
    vim.cmd "normal! Qn"
  else
    vim.cmd "normal! Q*"
  end
end, { desc = "Select next occurrence (multicursor)" })

map("x", "<C-n>", "Q", { desc = "Place cursor on each line of selection (multicursor)" })
