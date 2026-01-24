--------------------------------------------------------------------------------
-- Comment box module
--------------------------------------------------------------------------------

local M = {}
local H = {}

H.get_comment_parts = function()
  local cs = vim.bo.commentstring or "%s"
  local left, right = cs:match("^(.-)%%s(.-)$")
  return left or "", right or ""
end

H.get_comment_text_from_line = function()
  local left, right = H.get_comment_parts()
  local line = vim.api.nvim_get_current_line()

  local indent = line:match("^(%s*)") or ""

  -- Remove indent + left comment
  line = line:gsub("^%s*" .. vim.pesc(left), "", 1)

  -- Remove right comment if present
  if right ~= "" then
    line = line:gsub(vim.pesc(right) .. "%s*$", "", 1)
  end

  return vim.trim(line), indent .. left, right
end

H.align_text = function(text, inner_width, align)
  local margin = 4

  if #text > inner_width then
    text = text:sub(1, inner_width)
  end

  local remaining = inner_width - #text

  -- Not enough room for margins → fall back safely
  if remaining < margin * 2 then
    return text, 0, remaining
  end

  if align == "left" then
    return text, margin, remaining - margin
  elseif align == "right" then
    return text, remaining - margin, margin
  else -- center (default)
    local left = math.floor(remaining / 2)
    local right = remaining - left
    return text, left, right
  end
end

H.replace_line_with = function(lines)
  local line_num = vim.fn.line(".")
  vim.api.nvim_set_current_line(lines[1])
  vim.fn.append(line_num, vim.list_slice(lines, 2))
  return line_num
end

H.compute_inner_width = function(total_width, prefix, suffix, layout)
  local layouts = { box = 2, line = 4 }
  local overhead = layouts[layout]
  -- stylua: ignore
  if not overhead then return nil end

  local inner = total_width - #prefix - #suffix - overhead
  -- stylua: ignore
  if inner < 1 then return nil end

  return inner
end

H.join_comment = function(prefix, body, suffix)
  local left_space = prefix ~= "" and " " or ""
  local right_space = suffix ~= "" and " " or ""

  return prefix .. left_space .. body .. right_space .. suffix
end

M.toggle_box = function(opts)
  opts = opts or {}
  local align = opts.align or "center"
  local total_width = opts.width or 80

  local tl, tr, bl, br = "┌", "┐", "└", "┘"
  local h, v = "─", "│"

  local text, prefix, suffix = H.get_comment_text_from_line()
  if text == "" then
    return
  end

  local inner_width = H.compute_inner_width(total_width, prefix, suffix, "box")
  -- stylua: ignore
  if not inner_width then return end

  local aligned, left_pad, right_pad = H.align_text(text, inner_width, align)

  -- stylua: ignore
  local content = {
    tl .. string.rep(h, inner_width) .. tr,
    v .. string.rep(" ", left_pad) .. aligned .. string.rep(" ", right_pad) .. v,
    bl .. string.rep(h, inner_width) .. br,
  }

  for i, line in ipairs(content) do
    content[i] = H.join_comment(prefix, line, suffix)
  end

  local line_num = H.replace_line_with(content)

  vim.api.nvim_win_set_cursor(0, { line_num + 1, 0 })
end

M.toggle_line = function(opts)
  opts = opts or {}
  local align = opts.align or "left"
  local total_width = opts.width or 80

  local h = "─"

  local text, prefix, suffix = H.get_comment_text_from_line()
  if text == "" then
    return
  end

  local inner_width = H.compute_inner_width(total_width, prefix, suffix, "line")
  -- stylua: ignore
  if not inner_width then return end

  local aligned, left_pad, right_pad = H.align_text(text, inner_width, align)

  -- stylua: ignore
  local content = {
    string.rep(h, left_pad) .. " " .. aligned .. " " .. string.rep(h, right_pad)
  }

  for i, line in ipairs(content) do
    content[i] = H.join_comment(prefix, line, suffix)
  end

  local line_num = H.replace_line_with(content)

  -- Place cursor at start of the decorative line
  vim.api.nvim_win_set_cursor(0, { line_num, 0 })
end

return M
