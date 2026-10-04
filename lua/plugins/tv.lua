---@type LazySpec[]
return {
  {
    "alexpasmantier/tv.nvim",

    keys = {
      {
        "<leader>ff",
        function()
          require("tv").tv_channel "files"
        end,
        desc = "Find files (tv)",
      },
      {
        "<leader>cm",
        function()
          require("tv").tv_channel "git-log"
        end,
        desc = "Git commits (tv)",
      },
      {
        "<leader>fs",
        function()
          require("tv").tv_channel "definitions"
        end,
        desc = "Find symbols / definitions (tv)",
      },
    },

    opts = function()
      local h = require("tv").handlers

      return {
        -- width/height are fractions of the editor. The border is drawn outside that box.
        layout = "landscape",
        window = { width = 1.0, height = 1.0, border = "rounded", title_pos = "center" },

        -- Read only from `channels`; a top-level field is ignored.
        -- `args` replaces that channel's arguments, so the shared flags are repeated here.
        channels = {
          files = {
            args = { "--no-remote", "--no-status-bar", "--preview-size", "60" },
            handlers = {
              ["<CR>"] = h.open_as_files,
              ["<C-q>"] = h.send_to_quickfix,
              ["<C-s>"] = h.open_in_split,
              ["<C-v>"] = h.open_in_vsplit,
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          text = {
            args = { "--no-remote", "--no-status-bar", "--preview-size", "60" },
            handlers = {
              ["<CR>"] = h.open_at_line,
              ["<C-q>"] = h.send_to_quickfix,
              ["<C-x>"] = h.open_in_split,
              ["<C-v>"] = h.open_in_vsplit,
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          ["git-log"] = {
            -- No built-in handler shows a commit.
            handlers = {
              ["<CR>"] = function(entries)
                if entries[1] then
                  vim.cmd("tabnew | terminal git show " .. vim.fn.shellescape(entries[1]))
                end
              end,
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          definitions = {
            args = { "--no-remote", "--no-status-bar", "--preview-size", "60" },
            handlers = {
              ["<CR>"] = h.open_at_line,
              ["<C-q>"] = h.send_to_quickfix,
              ["<C-x>"] = h.open_in_split,
              ["<C-v>"] = h.open_in_vsplit,
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },
        },
      }
    end,
  },
}
