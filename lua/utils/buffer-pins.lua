local M = {}

M.pinned = {}

M.toggle = function(buf)
  M.pinned[buf] = not M.pinned[buf]
  if not M.pinned[buf] then
    M.pinned[buf] = nil
  end
end

M.is_pinned = function(buf)
  return M.pinned[buf] == true
end

M.clear = function(buf)
  M.pinned[buf] = nil
end

return M
