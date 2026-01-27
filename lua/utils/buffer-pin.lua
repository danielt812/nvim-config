-- #############################################################################
-- #                             Buffer pin module                             #
-- #############################################################################

local M = {}
local H = {}

-- Internal table storing pinned buffers.
-- Keys are buffer numbers, values are `true`.
H.pinned = {}

--- Pin a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.pin = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  H.pinned[buf] = true
end

--- Unpin a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.unpin = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  H.pinned[buf] = nil
end

--- Toggle pin state for a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.toggle = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  if H.pinned[buf] then
    H.pinned[buf] = nil
  else
    H.pinned[buf] = true
  end
end

--- Check whether a buffer is pinned.
--- @param buf number Buffer handle
--- @return boolean
M.is_pinned = function(buf)
  return H.pinned[buf] == true
end

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = vim.api.nvim_create_augroup("buffer_utils_pin_lifecycle", { clear = true }),
  desc = "Clear pinned buffer state on buffer removal",
  callback = function(args)
    H.pinned[args.buf] = nil
  end,
})

return M
