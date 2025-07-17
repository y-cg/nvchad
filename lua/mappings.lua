require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "Formatting" })

map("n", "<leader>qf", function()
  vim.lsp.buf.code_action()
end, { desc = "Quick fix" })

map("n", "<leader>f", function()
  vim.diagnostic.open_float { border = "rounded" }
end, { desc = "Floating diagnostic" })

-- cycle between buffer
map("n", "<S-L>", function()
  require("nvchad.tabufline").next()
end, { desc = "Goto next buffer" })

map("n", "<S-H>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Goto previous buffer" })

map("n", "<leader><leader>", "<cmd> Telescope find_files <CR>", { desc = "Find files" })
