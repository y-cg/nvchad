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

-- ----------------------------------------------------------------------------
-- tv.nvim picker bindings
-- ----------------------------------------------------------------------------
-- Replaces the NvChad-default Telescope bindings (and the user's old
-- `<leader><leader>` override) with calls into tv.nvim's channels.
--
-- Mappings are written as functions that lazily `require("tv")` so the plugin
-- is only loaded when the key is actually pressed, matching how NvChad's
-- own telescope mapping lazy-loaded via the `Telescope` cmd.

-- tv.nvim has no toggle: each call to `tv_channel` spawns a fresh picker
-- session in a new floating window (see `lua/tv/window.lua`). The helper
-- just dispatches to `tv_channel` so the same closure shape works for
-- every channel name (e.g. "files", "text", "git-log").
local tv = function(channel)
  return function()
    require("tv").tv_channel(channel)
  end
end

map("n", "<leader><leader>", tv "files", { desc = "Find files (tv)" })

-- Override NvChad's telescope defaults for the channels tv.nvim actually ships.
map("n", "<leader>ff", tv "files", { desc = "Find files (tv)" })
map("n", "<leader>fa", tv "files", { desc = "Find files (tv)" })
map("n", "<leader>fw", tv "text", { desc = "Live grep (tv)" })
map("n", "<leader>cm", tv "git-log", { desc = "Git commits (tv)" })

-- No-op the NvChad defaults that pointed at Telescope pickers tv.nvim has no
-- built-in channel for. Without this they would `E492: Not an editor command`
-- now that telescope is gone.
map("n", "<leader>fb", "<Nop>", { desc = "Buffers (disabled)" })
map("n", "<leader>fh", "<Nop>", { desc = "Help tags (disabled)" })
map("n", "<leader>fz", "<Nop>", { desc = "Fuzzy in buffer (disabled)" })
map("n", "<leader>fo", "<Nop>", { desc = "Old files (disabled)" })
map("n", "<leader>ma", "<Nop>", { desc = "Marks (disabled)" })
map("n", "<leader>gt", "<Nop>", { desc = "Git status (disabled)" })
map("n", "<leader>pt", "<Nop>", { desc = "Pick hidden term (disabled)" })

-- Leap.nvim mappings
map({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward to" })
map({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward to" })
