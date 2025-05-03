local M = { "echasnovski/mini.base16" }

M.enabled = false

M.event = { "VimEnter" }

M.config = function()
  local italic = { italic = true }

  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
  comment_hl = vim.tbl_deep_extend("force", comment_hl, italic)

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_set_hl(0, "Comment", comment_hl)
end

return M
