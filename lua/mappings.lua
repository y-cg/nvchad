local map = vim.keymap.set

-- ============================================================================
-- General editor mappings
-- ============================================================================
-- Mappings not owned by any plugin slice: builtins, editor habits (jk, ;),
-- and window navigation.
--
-- Deliberately does NOT `require "nvchad.mappings"`: we keep only the general
-- mappings we actually use instead of inheriting NvChad's full default set.
-- Plugin-specific mappings live in their slice's `keys` field; see CONTEXT.md
-- "Mapping ownership".

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })

map("n", "<Esc>", function()
  if vim.api.nvim_mcursor ~= nil then
    local ns = vim.api.nvim_create_namespace "nvim.multicursor"
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end
  vim.cmd "nohlsearch"
end, { desc = "Clear search highlights and multicursors" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

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
