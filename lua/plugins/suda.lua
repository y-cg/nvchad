-- vim-suda — transparently read/write files with sudo (:SudaRead / :SudaWrite)
---@type LazySpec
return {
  "lambdalisue/vim-suda",
  lazy = false,
  init = function()
    -- Disable suda's built-in global smart_edit because it naively wipes /nix/store buffers.
    vim.g.suda_smart_edit = 0

    -- Custom smart_edit: auto-switch to suda:// for unwritable files (e.g. /etc/hosts)
    -- while explicitly ignoring /nix/ paths and symlinks pointing to /nix/store.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("SudaSmartEditCustom", { clear = true }),
      pattern = "*",
      nested = true,
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) then
          return
        end

        local path = vim.api.nvim_buf_get_name(args.buf)
        if path == "" or vim.bo[args.buf].buftype ~= "" or vim.fn.isdirectory(path) == 1 then
          return
        end

        -- Skip URLs/schemes (suda://, oil://, etc.)
        if path:find "^[a-z]+://" then
          return
        end

        -- Explicitly ignore /nix/store paths
        local realpath = vim.uv.fs_realpath(path) or path
        if vim.startswith(path, "/nix/store") then
          return
        end

        -- Skip if already checked or writable
        if vim.b[args.buf].suda_smart_edit_checked then
          return
        end
        vim.b[args.buf].suda_smart_edit_checked = true

        -- Switch unwritable system files to suda://
        if vim.fn.filereadable(path) == 1 and vim.fn.filewritable(path) == 0 then
          vim.cmd(string.format("keepalt keepjumps edit suda://%s", vim.fn.fnameescape(vim.fn.fnamemodify(path, ":p"))))
          vim.cmd(string.format("silent! %dbwipeout", args.buf))
        end
      end,
    })
  end,
}
