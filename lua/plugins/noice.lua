-- noice.nvim — floating messages / cmdline / notifications.
-- Replaces the bottom echo area with dismissable top-right cards (via
-- nvim-notify), so transient errors don't vanish on the next redraw.
-- snacks.nvim's `notifier` is off (only `picker`/`input` enabled there),
-- so there's no second notifier competing for `vim.notify`.

---@type LazySpec
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },

  -- noice zeroes cmdheight during setup(), collapsing the blank line between
  -- the statusline and the outer tmux statusline. `init` is too early
  -- (overwritten by setup); `vim.schedule` after setup lands after noice's
  -- own scheduled work and restores the gap.
  init = function()
    vim.opt.cmdheight = 1
  end,

  opts = {
    notify = { enabled = true },
    cmdline = { enabled = true, view = "cmdline" },
    presets = { lsp_doc_border = true },

    -- Avoid per-keystroke progress cards; NvChad's statusline shows LSP progress.
    lsp = { progress = { enabled = false } },
  },

  -- `<C-b>` is Herdr's prefix; use `<C-d>`/`<C-u>` for doc scrolling.
  keys = {
    {
      "<C-d>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<C-d>"
        end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Scroll LSP doc down",
    },
    {
      "<C-u>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<C-u>"
        end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Scroll LSP doc up",
    },
  },

  config = function(_, opts)
    require("noice").setup(opts)
    vim.schedule(function()
      vim.opt.cmdheight = 1
    end)
  end,
}
