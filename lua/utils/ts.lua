local M = {}

---Return a value only if cursor is inside a Tree-sitter capture
---@param capture string|string[]
---@param value any
---@return fun(buf_id: number, _: any, data: table): any|nil
M.if_capture = function(capture, value)
  local wanted = type(capture) == "table" and capture or { capture }

  return function(buf_id, _, data)
    local captures = vim.treesitter.get_captures_at_pos(buf_id, data.line - 1, data.from_col - 1)

    for _, c in ipairs(captures) do
      if vim.tbl_contains(wanted, c.capture) then return value end
    end

    return nil
  end
end

---Return a value only if cursor is NOT inside a Tree-sitter capture
---@param capture string|string[]
---@param value any
---@return fun(buf_id: number, _: any, data: table): any|nil
M.if_not_capture = function(capture, value)
  local wanted = type(capture) == "table" and capture or { capture }

  return function(buf_id, _, data)
    local captures = vim.treesitter.get_captures_at_pos(buf_id, data.line - 1, data.from_col - 1)

    for _, c in ipairs(captures) do
      if vim.tbl_contains(wanted, c.capture) then return nil end
    end

    return value
  end
end

return M
