-- vim-wakatime — automatically track coding time with WakaTime
---@type LazySpec
return {
  "wakatime/vim-wakatime",
  -- Skip loading when the WakaTime token is missing or empty — otherwise the
  -- plugin attempts to authenticate on every keypress and produces errors.
  cond = function()
    local token_path = vim.fn.expand "~/.wakatime/token"
    return vim.fn.filereadable(token_path) == 1 and vim.fn.getfsize(token_path) > 0
  end,
  lazy = false,
}
