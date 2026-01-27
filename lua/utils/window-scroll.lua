-- Window scroll module

local M = {}
local H = {}

H.opts = {
  center_after_scroll = true,
}

--- Move the cursor vertically by a given number of lines.
---@param count integer Number of lines to move
---@param direction '"down"'|'"up"'
H.move_lines = function(count, direction)
  -- stylua: ignore
  if count <= 0 then return end

  local motion = direction == "down" and "j" or "k"
  vim.cmd("normal! " .. count .. motion)
end

--- Calculate the number of lines for a page-sized movement.
---@param size '"full"'|'"half"' Page size to calculate
---@return integer lines
H.get_page_size = function(size)
  local height = vim.api.nvim_win_get_height(0)

  if size == "half" then return math.floor(height / 2) end

  return height - 2
end

H.get_scroll_amount = function()
  -- return vim.o.scroll > 0
  --   and vim.o.scroll
  --   or math.floor(vim.api.nvim_win_get_height(0) / 2)
  return math.floor(vim.api.nvim_win_get_height(0) / 2)
end

H.normal_key = function(key) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", true) end

--- Move the cursor down by one full page.
M.page_down = function()
  local count = H.get_page_size("full")
  H.move_lines(count, "down")
end

--- Move the cursor up by one full page.
M.page_up = function()
  local count = H.get_page_size("full")
  H.move_lines(count, "up")
end

--- Move the cursor down by half a page.
M.half_page_down = function()
  local count = H.get_page_size("half")
  H.move_lines(count, "down")
end

--- Move the cursor up by half a page.
M.half_page_up = function()
  local count = H.get_page_size("half")
  H.move_lines(count, "up")
end

return M
