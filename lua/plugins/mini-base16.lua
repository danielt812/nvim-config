local M = { "echasnovski/mini.base16" }

M.enabled = true

M.event = { "VimEnter" }

M.priority = 1000

M.config = function()
  vim.cmd("colorscheme gruvbox")
end

return M
