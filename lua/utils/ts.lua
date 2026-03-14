local M = {}

---Return a value only if cursor is inside a Tree-sitter capture
---@param capture string|string[]
---@param value any
---@return fun(buf_id: number, _: any, data: table): any|nil
M.if_capture = function(capture, value)
  capture = type(capture) == "table" and capture or { capture }
  return function(buf_id, _, data)
    local captures = vim.treesitter.get_captures_at_pos(buf_id, data.line - 1, data.from_col - 1)

    for _, c in ipairs(captures) do
      if vim.tbl_contains(capture, c.capture) then return value end
    end

    return nil
  end
end

---Return a value only if cursor is NOT inside a Tree-sitter capture
---@param capture string|string[]
---@param value any
---@return fun(buf_id: number, _: any, data: table): any|nil
M.if_not_capture = function(capture, value)
  capture = type(capture) == "table" and capture or { capture }
  return function(buf_id, _, data)
    local captures = vim.treesitter.get_captures_at_pos(buf_id, data.line - 1, data.from_col - 1)

    for _, c in ipairs(captures) do
      if vim.tbl_contains(capture, c.capture) then return nil end
    end

    return value
  end
end

---Check if the current buffer has a Tree-sitter parser
---@return boolean
M.has_parser = function()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, nil, { error = false })
  return ok and parser ~= nil
end

---Check if the cursor is inside (or on) a Tree-sitter node of the given type(s)
---@param node_type string|string[]
---@return boolean
M.in_node = function(node_type)
  node_type = type(node_type) == "table" and node_type or { node_type }
  local node = vim.treesitter.get_node()
  while node do
    if vim.tbl_contains(node_type, node:type()) then return true end
    node = node:parent()
  end
  return false
end

return M
