local map = vim.keymap.set

-- ============================================================================
-- General editor mappings
-- ============================================================================
-- Mappings not owned by any plugin slice: builtins, editor habits (jk, ;),
-- and window navigation.

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
