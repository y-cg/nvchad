---@type LazySpec
return {
  "julienvincent/hunk.nvim",
  cmd = { "DiffEditor" },
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    local function nowrap(win)
      vim.wo[win].wrap = false
      vim.wo[win].linebreak = false
    end

    -- hunk.Config requires every field, but setup() takes partial overrides.
    ---@diagnostic disable: missing-fields
    require("hunk").setup {
      keys = {
        tree = {
          expand_node = { "zo" },
          collapse_node = { "zc" },
        },
      },
      hooks = {
        -- nui's NuiTree type declares fields but not methods, so treat it as opaque.
        ---@param ctx { buf: number, tree: any, opts: table }
        on_tree_mount = function(ctx)
          nowrap(ctx.opts.winid)

          -- on_toggle calls this as `opts.tree.render()` (no self), so mimic Component.
          local function render_tree()
            ctx.tree:render()
          end
          local cb = { tree = { render = render_tree } }

          -- `a` is normal-mode only upstream; add visual mode (file nodes only).
          vim.keymap.set("x", "a", function()
            -- `'<`/`'>` are unset inside an x-mode mapping; use `v` and `.`.
            local first, last = vim.fn.line "v", vim.fn.line "."
            if first > last then
              first, last = last, first
            end

            for line = first, last do
              local node = ctx.tree:get_node(line)
              if node and node.type == "file" then
                ctx.opts.on_toggle(node.change, nil, cb)
              end
            end

            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
          end, { buffer = ctx.buf, nowait = true, desc = "Toggle files in selection" })
        end,
        on_diff_mount = function(ctx)
          nowrap(ctx.win)
        end,
      },
    }
    ---@diagnostic enable: missing-fields
  end,
}
