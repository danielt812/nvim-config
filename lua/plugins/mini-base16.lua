local M = { "echasnovski/mini.base16" }

M.enabled = true

M.event = { "VimEnter" }

M.priority = 1000

M.config = function()
  vim.cmd("colorscheme everforest")

  -- Set the highlight with the updated settings
  vim.api.nvim_set_hl(0, "Comment", { fg = "#665c54", italic = true })
end

return M
