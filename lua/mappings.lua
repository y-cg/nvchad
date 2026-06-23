local map = vim.keymap.set

-- ============================================================================
-- General editor mappings
-- ============================================================================
-- Inlined from nvchad.mappings — only the subset we actually use.
-- Telescope, NvimTree, WhichKey, and terminal mappings from nvchad.mappings
-- are intentionally omitted.

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- ----------------------------------------------------------------------------
-- Tabufline
-- ----------------------------------------------------------------------------
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto previous buffer" })

map("n", "<S-L>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })

map("n", "<S-H>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto previous buffer" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })

-- ----------------------------------------------------------------------------
-- Comment
-- ----------------------------------------------------------------------------
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ============================================================================
-- LSP builtins
-- ============================================================================
-- vim.diagnostic / vim.lsp are builtins with no plugin slice to attach to.
map("n", "<leader>qf", function()
  vim.lsp.buf.code_action()
end, { desc = "Quick fix" })

map("n", "<leader>f", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })
