local M = { "echasnovski/mini.base16" }

M.enabled = false

M.event = { "VimEnter" }

M.config = function()
  print("HELLO?")
  -- vim.cmd("colorscheme everforest")

  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })

  -- Reapply it with italic
  comment_hl.italic = true

  vim.api.nvim_set_hl(0, "Comment", comment_hl)
end

return M
