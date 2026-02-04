-- #############################################################################
-- #                               Boxes Module                                #
-- #############################################################################

local ModBoxes = {}
local H = {}

ModBoxes.setup = function(config)
  -- Export module
  _G.ModBoxes = ModBoxes

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

ModBoxes.config = {
  mappings = {
    box = "gbb",
    line = "gbl",
  },

  box = {
    char = "#",
    alt = "*",
    justify = "center",
    width = 80,
  },

  line = {
    char = "-",
    alt = "",
    justify = "left",
    width = 80,
  },
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModBoxes.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")
  H.check_type("mappings.box", config.mappings.box, "string")
  H.check_type("mappings.line", config.mappings.line, "string")

  H.check_type("box", config.box, "table")
  H.check_type("box.char", config.box.char, "string")
  H.check_type("box.alt", config.box.alt, "string")
  H.check_type("box.justify", config.box.justify, "string")
  H.check_type("box.width", config.box.width, "number")

  H.check_type("line", config.line, "table")
  H.check_type("line.char", config.line.char, "string")
  H.check_type("line.alt", config.line.alt, "string")
  H.check_type("line.justify", config.line.justify, "string")
  H.check_type("line.width", config.line.width, "number")

  return config
end

H.apply_config = function(config)
  ModBoxes.config = config

  -- Create mappings
  H.map("n", config.mappings.box, ModBoxes.toggle_box, { desc = "Create Box" })
  H.map("n", config.mappings.line, ModBoxes.toggle_line, { desc = "Create Line" })
end

H.is_disabled = function() return vim.g.boxcomments_disable == true or vim.b.boxcomments_disable == true end

H.get_config = function() return vim.tbl_deep_extend("force", ModBoxes.config, vim.b.boxcomments_config or {}) end

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

H.compute_body_width = function(total_width, prefix, suffix)
  local left_gap = prefix ~= "" and 1 or 0
  local right_gap = suffix ~= "" and 1 or 0
  local inner = total_width - #prefix - #suffix - left_gap - right_gap
  if inner < 1 then return nil end
  return inner
end

H.pick_char = function(primary, alt)
  local cs = vim.bo.commentstring or ""
  if primary ~= "" and cs:find(primary, 1, true) then
    if type(alt) == "string" and alt ~= "" then return alt end
  end
  return primary
end

H.detect_line_char = function(text, primary, alt)
  if primary and primary ~= "" and H.is_ascii_line(text, primary) then return primary end
  if alt and alt ~= "" and H.is_ascii_line(text, alt) then return alt end
  return nil
end

H.detect_box_char = function(lines3, prefix, suffix, primary, alt)
  if primary and primary ~= "" and H.is_box_lines(lines3, prefix, suffix, primary) then return primary end
  if alt and alt ~= "" and H.is_box_lines(lines3, prefix, suffix, alt) then return alt end
  return nil
end

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

H.join_comment = function(prefix, body, suffix) return prefix .. body .. suffix end

H.wrap_comment = function(prefix, body, suffix)
  if prefix ~= "" then body = " " .. body end
  if suffix ~= "" then body = body .. " " end
  return H.join_comment(prefix, body, suffix)
end

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

H.check_one_byte = function(name, s)
  if type(s) ~= "string" then H.error(string.format("`%s` should be string, not %s", name, type(s))) end
  if s == "" then
    H.error(string.format("`%s` must not be empty", name))
  end
  if s ~= "" and #s ~= 1 then H.error(string.format("`%s` must be exactly 1 byte", name)) end
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

-- Public API ------------------------------------------------------------------
ModBoxes.toggle_line = function(width, char, justify)
  if H.is_disabled() then return end

  local config = H.get_config()
  justify = justify or config.line.justify
  width = width or config.line.width

  local primary = config.line.char
  local alt = config.line.alt

  local prefix, suffix, text = H.get_subject()
  if not text or text == "" then return end

  -- Toggle off (match either primary or alt)
  local used = H.detect_line_char(text, primary, alt)
  if used then
    vim.api.nvim_set_current_line(H.unwrap_line(prefix, text, suffix, used))
    return
  end

  -- Toggle on (choose char based on commentstring unless caller passed one)
  char = char or H.pick_char(primary, alt)
  H.check_one_byte("char", char)

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

ModBoxes.toggle_box = function(width, char, justify)
  if H.is_disabled() then return end

  local config = H.get_config()
  width = width or config.box.width
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

  -- Toggle off: if cursor is on any line of a 3-line box (primary or alt)
  local primary = config.box.char
  local alt = config.box.alt

  -- Try the 3 possible starts for a 3-line box that could include `row`
  for start = row - 2, row do
    if start >= 0 then
      local lines3 = vim.api.nvim_buf_get_lines(buf, start, start + 3, false)
      local used = H.detect_box_char(lines3, prefix, suffix, primary, alt)

      if used then
        local unboxed = H.unwrap_box_to_line(lines3, prefix, suffix, used)
        if unboxed then
          vim.api.nvim_buf_set_lines(buf, start, start + 3, false, { unboxed })
          vim.api.nvim_win_set_cursor(0, { start + 1, 0 })
        end
        return
      end
    end
  end

  -- Toggle on: works for commented and non-commented
  char = char or H.pick_char(primary, alt)
  H.check_one_byte("char", char)

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
H.error = function(msg) error("(module.boxes) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return ModBoxes
