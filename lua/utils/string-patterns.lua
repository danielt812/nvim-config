local M = {}

-- Normalize a full hex color (#rrggbb)
-- Currently just returns the match, but keeps the API consistent
-- with other converters and allows future normalization.
---@param match string
---@return string
function M.get_hex_long(match)
  return match
end

-- Expand a short hex color (#rgb -> #rrggbb)
---@param match string
---@return string
function M.get_hex_short(match)
  local r = match:sub(2, 2)
  local g = match:sub(3, 3)
  local b = match:sub(4, 4)

  return string.format("#%s%s%s%s%s%s", r, r, g, g, b, b):lower()
end

-- Convert rgb(r, g, b) to hex (#rrggbb)
---@param match string
---@return string
function M.rgb_color(match)
  local red, green, blue = match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")

  return string.format("#%02x%02x%02x", tonumber(red), tonumber(green), tonumber(blue))
end

-- Convert rgba(r, g, b, a) to hex (#rrggbb), applying alpha
---@param match string
---@return string|false
function M.rgba_color(match)
  local red, green, blue, alpha = match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")

  alpha = tonumber(alpha)
  if not alpha or alpha < 0 or alpha > 1 then
    return false
  end

  return string.format("#%02x%02x%02x", tonumber(red) * alpha, tonumber(green) * alpha, tonumber(blue) * alpha)
end

return M
