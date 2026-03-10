local M = {}

--- Create new highlight with inherited fg and bg of two existing groups
--- @param fg_name string
--- @param bg_name string
--- @param new_name string
M.merge_hl = function(fg_name, bg_name, new_name)
  local fg_hl = vim.api.nvim_get_hl(0, { name = fg_name, link = false })
  local bg_hl = vim.api.nvim_get_hl(0, { name = bg_name, link = false })
  local fg, bg = fg_hl.fg, bg_hl.bg
  vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
end

return M
