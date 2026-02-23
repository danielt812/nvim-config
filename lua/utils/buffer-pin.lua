-- #############################################################################
-- #                             Buffer pin module                             #
-- #############################################################################

local M = {}
local H = {}

-- Internal table storing pinned buffers.
-- Keys are buffer numbers, values are `true`.
H.pinned = {}

--- Redraw tabline so ui updates immediately
H.redraw = function()
  vim.cmd("redrawtabline")
end

--- Pin a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.pin = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  H.pinned[buf] = true
  H.redraw()
end

--- Unpin a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.unpin = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  H.pinned[buf] = nil
  H.redraw()
end

--- Toggle pin state for a buffer.
--- @param buf? number Optional buffer handle (defaults to current buffer)
M.toggle = function(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  H.pinned[buf] = not H.pinned[buf] or nil
  H.redraw()
end

--- Check whether a buffer is pinned.
--- @param buf number Buffer handle
--- @return boolean
M.is_pinned = function(buf)
  return H.pinned[buf] == true
end

local buffer_pin_augroup = vim.api.nvim_create_augroup("buffer_utils_pin_lifecycle", { clear = true })

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = buffer_pin_augroup,
  desc = "Clear pinned buffer state on buffer removal",
  callback = function(args)
    H.pinned[args.buf] = nil
  end,
})

return M
