-- Highlight caches compiled by base46. Plugin specs do not dofile them.
local M = {}

local caches = {
  "defaults",
  "statusline",
  "syntax",
  "treesitter",
  "blink",
  "whichkey",
  "devicons",
  "lsp",
  "git",
  "blankline",
  "tbline",
}

-- setup() copies IblChar, then replaces @ibl.scope.underline.*.
local after_load = {
  ["indent-blankline.nvim"] = { "blankline" },
}

local function apply(names)
  for _, name in ipairs(names) do
    local path = vim.g.base46_cache .. name
    if vim.uv.fs_stat(path) then
      dofile(path)
    end
  end
end

function M.load()
  apply(caches)

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("base46-highlights", { clear = true }),
    pattern = "LazyLoad",
    callback = function(ev)
      local names = after_load[ev.data]
      if names then
        apply(names)
      end
    end,
  })
end

return M
