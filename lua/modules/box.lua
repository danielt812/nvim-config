-- #############################################################################
-- #                               Ascii Module                                #
-- #############################################################################

local M = {}
local H = {}

M.setup = function(config)
  config = H.setup_config(config)
  H.apply_config(config)
end

M.config = {
  mappings = {
    box = "gbb",
    line = "gbl",
  },

  box = {
    char = "#",
    justify = "center",
    width = 80,
  },

  line = {
    char = "-",
    justify = "left",
    width = 80,
  },
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(M.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")
  H.check_type("mappings.box", config.mappings.box, "string")
  H.check_type("mappings.line", config.mappings.line, "string")

  H.check_type("box", config.box, "table")
  H.check_type("box.char", config.box.char, "string")
  H.check_type("box.justify", config.box.justify, "string")
  H.check_type("box.width", config.box.width, "number")

  H.check_type("line", config.line, "table")
  H.check_type("line.char", config.line.char, "string")
  H.check_type("line.justify", config.line.justify, "string")
  H.check_type("line.width", config.line.width, "number")

  return config
end

H.apply_config = function(config)
  M.config = config

  -- Create mappings
  H.map("n", config.mappings.box, M.toggle_box, { desc = "Comment Box" })
  H.map("n", config.mappings.line, M.toggle_line, { desc = "Comment Line" })

  vim.keymap.set("n", "<C-r>", function()
    package.loaded["modules.box"] = nil
    require("modules.box").setup()
    vim.notify("modules.box reloaded")
  end, { desc = "Reload Box Module" })
end

H.is_disabled = function() return vim.g.asciicomments_disable == true or vim.b.asciicomments_disable == true end

H.get_config = function() return vim.tbl_deep_extend("force", M.config, vim.b.asciicomments_config or {}) end

H.get_comment_parts = function()
  local cs = vim.bo.commentstring or "%s"
  local cs_left, cs_right = cs:match("^(.-)%%s(.-)$")
  return cs_left or "", cs_right or ""
end

H.get_line_parts = function()
  local cs_left, cs_right = H.get_comment_parts()
  local line = vim.api.nvim_get_current_line()

  local indent = line:match("^%s*") or ""
  local prefix = (indent .. cs_left):gsub("%s+$", "")
  local suffix = cs_right:gsub("^%s+", "")

  local pattern
  if cs_right ~= "" then
    pattern = "^" .. vim.pesc(prefix) .. "%s*(.-)%s*" .. vim.pesc(suffix) .. "%s*$"
  else
    pattern = "^" .. vim.pesc(prefix) .. "%s*(.-)%s*$"
  end

  local text = line:match(pattern)
  return prefix, text, suffix
end

-- Unifies "commented or not": always returns prefix/suffix to use + extracted text
H.get_subject = function()
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""

  local cs_left, cs_right = H.get_comment_parts()
  local fallback_prefix = (indent .. cs_left):gsub("%s+$", "")
  local fallback_suffix = cs_right:gsub("^%s+", "")

  local prefix, text, suffix = H.get_line_parts()

  if text ~= nil then return prefix, suffix, text, indent, line end

  local plain = line:gsub("^%s*", "")
  return fallback_prefix, fallback_suffix, plain, indent, line
end

H.compute_inner_width = function(total_width, prefix, suffix)
  local indent = prefix:match("^%s*") or ""
  local inner = total_width - #indent - (#prefix - #indent) - #suffix
  if inner < 1 then return nil end
  return inner
end

H.join_comment = function(prefix, body, suffix) return prefix .. body .. suffix end

H.wrap_comment = function(prefix, body, suffix)
  if prefix ~= "" then body = " " .. body end
  if suffix ~= "" then body = body .. " " end
  return H.join_comment(prefix, body, suffix)
end

H.compute_body_width = function(total_width, prefix, suffix)
  local left_gap = prefix ~= "" and 1 or 0
  local right_gap = suffix ~= "" and 1 or 0
  local inner = total_width - #prefix - #suffix - left_gap - right_gap
  if inner < 1 then return nil end
  return inner
end

-- Width includes " " .. text .. " "
H.justify_pads = function(text_len, width, justify)
  local remaining = width - (text_len + 2)
  if remaining < 0 then return nil end

  if justify == "left" then return 0, remaining end
  if justify == "right" then return remaining, 0 end
  if justify == "center" then
    local left = math.floor(remaining / 2)
    return left, remaining - left
  end

  H.error("Invalid justify: " .. tostring(justify))
end

H.build_ascii_line_body = function(text, char, left_pad, right_pad)
  return table.concat({
    string.rep(char, left_pad),
    text,
    string.rep(char, right_pad),
  }, " ")
end

-- Detect: chars on either side (left/right/center formats)
H.is_ascii_line = function(text, char)
  local esc = vim.pesc(char)
  return text:match("^" .. esc .. "+%s+.+$") ~= nil -- right-justified
    or text:match("^.+%s+" .. esc .. "+$") ~= nil -- left-justified
    or text:match("^" .. esc .. "+%s+.+%s+" .. esc .. "+$") ~= nil -- centered
end

H.unwrap_line = function(prefix, text, suffix, char)
  local esc = vim.pesc(char)
  local stripped = text:gsub("^" .. esc .. "+%s+", "", 1):gsub("%s+" .. esc .. "+$", "", 1)

  local body = stripped
  if prefix ~= "" then body = " " .. body end
  if suffix ~= "" then body = body .. " " end

  return H.join_comment(prefix, body, suffix)
end

-- Extract the body from a full line (inverse of wrap_comment)
H.extract_body = function(line, prefix, suffix)
  if not vim.startswith(line, prefix) then return nil end
  local rest = line:sub(#prefix + 1)

  if prefix ~= "" then rest = rest:gsub("^%s", "", 1) end

  if suffix ~= "" then
    local body = rest:match("^(.-)%s*" .. vim.pesc(suffix) .. "$")
    if not body then return nil end
    body = body:gsub("%s$", "", 1)
    return body
  end

  return rest
end

H.is_box_lines = function(lines, prefix, suffix, char)
  if #lines ~= 3 then return false end
  local esc = vim.pesc(char)

  local top = H.extract_body(lines[1], prefix, suffix)
  local mid = H.extract_body(lines[2], prefix, suffix)
  local bot = H.extract_body(lines[3], prefix, suffix)
  if not top or not mid or not bot then return false end

  if top:match("^" .. esc .. "+$") == nil then return false end
  if bot ~= top then return false end

  if #mid ~= #top then return false end
  if mid:match("^" .. esc) == nil then return false end
  if mid:match(esc .. "$") == nil then return false end

  return true
end

H.unwrap_box_to_line = function(lines, prefix, suffix, char)
  local esc = vim.pesc(char)
  local mid = H.extract_body(lines[2], prefix, suffix)
  if not mid then return nil end

  local stripped =
    mid:gsub("^" .. esc .. "%s*", "", 1):gsub("%s*" .. esc .. "$", "", 1):gsub("^%s+", ""):gsub("%s+$", "")

  local body = stripped
  if prefix ~= "" then body = " " .. body end
  if suffix ~= "" then body = body .. " " end

  return H.join_comment(prefix, body, suffix)
end

H.build_box_middle_body = function(text, char, body_width, justify)
  -- middle body: <edge><space><(inner_text_width chars)><space><edge>
  local inner_text_width = body_width - 4
  if inner_text_width < #text then return nil end

  local remaining = inner_text_width - #text
  local left_spaces, right_spaces = 0, 0

  if justify == "left" then
    left_spaces, right_spaces = 0, remaining
  elseif justify == "right" then
    left_spaces, right_spaces = remaining, 0
  elseif justify == "center" then
    left_spaces = math.floor(remaining / 2)
    right_spaces = remaining - left_spaces
  else
    return nil
  end

  return char .. " " .. string.rep(" ", left_spaces) .. text .. string.rep(" ", right_spaces) .. " " .. char
end

H.replace_with = function(lines)
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.fn.line(".") - 1
  vim.api.nvim_buf_set_lines(buf, row, row + 1, false, lines)
end

-- Public API ------------------------------------------------------------------
M.toggle_line = function(width, char, justify)
  local config = H.get_config()
  justify = justify or config.line.justify
  char = char or config.line.char
  width = width or config.line.width

  local prefix, suffix, text = H.get_subject()
  if not text or text == "" then return end

  -- Toggle off
  if H.is_ascii_line(text, char) then
    vim.api.nvim_set_current_line(H.unwrap_line(prefix, text, suffix, char))
    return
  end

  local inner_width = H.compute_inner_width(width, prefix, suffix)
  if not inner_width then
    vim.notify("Not enough width for comment line", vim.log.levels.ERROR)
    return
  end

  local left_pad, right_pad = H.justify_pads(#text, inner_width, justify)
  if left_pad == nil or right_pad == nil then
    vim.notify("Unable to justify text", vim.log.levels.ERROR)
    return
  end

  local body = H.build_ascii_line_body(text, char, left_pad, right_pad)
  vim.api.nvim_set_current_line(H.join_comment(prefix, body, suffix))
end

M.toggle_box = function(width, char, justify)
  local config = H.get_config()
  width = width or config.box.width
  char = char or config.box.char
  justify = justify or config.box.justify

  local buf = vim.api.nvim_get_current_buf()
  local row = vim.fn.line(".") - 1

  -- For box detection we need prefix/suffix that include indent (even if line isn't commented)
  local prefix, suffix = (function()
    local line = vim.api.nvim_get_current_line()
    local indent = line:match("^%s*") or ""
    local cs_left, cs_right = H.get_comment_parts()
    return (indent .. cs_left):gsub("%s+$", ""), cs_right:gsub("^%s+", "")
  end)()

  -- Toggle off: if cursor is on the TOP line of a 3-line box
  local lines3 = vim.api.nvim_buf_get_lines(buf, row, row + 3, false)
  if H.is_box_lines(lines3, prefix, suffix, char) then
    local unboxed = H.unwrap_box_to_line(lines3, prefix, suffix, char)
    if unboxed then vim.api.nvim_buf_set_lines(buf, row, row + 3, false, { unboxed }) end
    return
  end

  -- Toggle on: works for commented and non-commented
  local pfx, sfx, text = H.get_subject()
  if not text or text == "" then return end

  local body_width = H.compute_body_width(width, pfx, sfx)
  if not body_width then
    vim.notify("Not enough width for box", vim.log.levels.ERROR)
    return
  end

  local border_body = string.rep(char, body_width)
  local top = H.wrap_comment(pfx, border_body, sfx)
  local bottom = top

  local middle_body = H.build_box_middle_body(text, char, body_width, justify)
  if not middle_body then
    vim.notify("Box text is longer than allowed width", vim.log.levels.ERROR)
    return
  end

  local middle = H.wrap_comment(pfx, middle_body, sfx)

  vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { top, middle, bottom })
end


-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(ascii) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
