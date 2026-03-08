local comment = require("mini.comment")

local comment_strings = {
  default = {
    html = "<!-- %s -->",
    css = "/* %s */",
    scss = "/* %s */",
    less = "/* %s */",
    javascript = "// %s",
    typescript = "// %s",
    tsx = "// %s",
  },

  overrides = {},
}

local jsx_overrides = {
  jsx_element = "{/* %s */}",
  jsx_fragment = "{/* %s */}",
  jsx_self_closing_element = "{/* %s */}",
}

for _, lang in ipairs({ "tsx", "javascript", "typescript" }) do
  comment_strings.overrides[lang] = jsx_overrides
end

local function override_cs(lang, node)
  local lang_overrides = comment_strings.overrides[lang]
  if not lang_overrides then return nil end

  while node do
    local cs = lang_overrides[node:type()]
    if cs then return cs end
    node = node:parent()
  end

  return nil
end

local function custom_commentstring()
  local ft = vim.bo.filetype
  local fallback = comment_strings.default[ft] or vim.bo.commentstring

  local parser_ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not parser_ok or not parser then return fallback end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*()")
  if indent and col < indent - 1 then col = indent - 1 end

  local language_tree = parser:language_for_range({ row, col, row, col })
  local lang = language_tree and language_tree:lang() or nil
  if not lang then return vim.bo.commentstring end

  local node = vim.treesitter.get_node({ pos = { row, col }, ignore_injections = false })
  local override = node and override_cs(lang, node)
  if override then return override end

  return comment_strings.default[lang] or vim.bo.commentstring
end

comment.setup({
  mappings = {
    comment = "gc",
    comment_line = "gcc",
    textobject = "gc",
  },
  options = {
    ignore_blank_line = true,
    pad_comment = false,
    custom_commentstring = custom_commentstring,
  },
  commentstring = {
    enable = true,
    fallback = "# %s",
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local get_comment_parts = function()
  local cs = custom_commentstring() or vim.bo.commentstring or "%s"
  local cs_left, cs_right = cs:match("^(.-)%%s(.-)$")
  return (cs_left or ""):gsub("%s+$", ""), (cs_right or ""):gsub("^%s+", "")
end

local get_body_width = function(width, prefix, suffix)
  local left_gap = prefix ~= "" and 1 or 0
  local right_gap = suffix ~= "" and 1 or 0
  return width - #prefix - #suffix - left_gap - right_gap
end

local wrap_body = function(body, prefix, suffix)
  if prefix ~= "" then body = " " .. body end
  if suffix ~= "" then body = body .. " " end
  return prefix .. body .. suffix
end

local calc_pads = function(remaining, justify)
  if justify == "left" then return 0, remaining end
  if justify == "right" then return remaining, 0 end
  local left = math.floor(remaining / 2)
  return left, remaining - left
end

local comment_box = function(text, char, justify, width)
  char = char or "#"
  justify = justify or "center"
  width = width or 80

  local prefix, suffix = get_comment_parts()
  local body_width = get_body_width(width, prefix, suffix)
  if body_width < 1 then
    vim.notify("Not enough width for box", vim.log.levels.ERROR)
    return
  end

  local border = wrap_body(string.rep(char, body_width), prefix, suffix)

  local inner_text_width = body_width - 4
  if inner_text_width < #text then
    vim.notify("Box text is longer than allowed width", vim.log.levels.ERROR)
    return
  end

  local left_pad, right_pad = calc_pads(inner_text_width - #text, justify)
  local middle_body = char .. " " .. string.rep(" ", left_pad) .. text .. string.rep(" ", right_pad) .. " " .. char
  local middle = wrap_body(middle_body, prefix, suffix)

  local row = vim.fn.line(".") - 1
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, { border, middle, border })
end

local comment_line = function(text, char, justify, width)
  char = char or "-"
  justify = justify or "left"
  width = width or 80

  local prefix, suffix = get_comment_parts()
  local body_width = get_body_width(width, prefix, suffix)
  if body_width < 1 then
    vim.notify("Not enough width for comment line", vim.log.levels.ERROR)
    return
  end

  local num_spaces = justify == "center" and 2 or 1
  local remaining = body_width - #text - num_spaces
  if remaining < 0 then
    vim.notify("Line text is longer than allowed width", vim.log.levels.ERROR)
    return
  end

  local left_pad, right_pad = calc_pads(remaining, justify)
  local parts = {}
  if left_pad > 0 then parts[#parts + 1] = string.rep(char, left_pad) end
  parts[#parts + 1] = text
  if right_pad > 0 then parts[#parts + 1] = string.rep(char, right_pad) end
  local body = table.concat(parts, " ")

  local row = vim.fn.line(".") - 1
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, { wrap_body(body, prefix, suffix) })
end

local comment_box_cb = function()
  vim.ui.input({ prompt = "Box text: " }, function(text)
    if not text then return end
    comment_box(text)
  end)
end

local comment_line_cb = function()
  vim.ui.input({ prompt = "Line text: " }, function(text)
    if not text then return end
    comment_line(text)
  end)
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>cb", comment_box_cb,  { desc = "Box" })
vim.keymap.set("n", "<leader>cl", comment_line_cb, { desc = "Line" })
-- stylua: ignore end
