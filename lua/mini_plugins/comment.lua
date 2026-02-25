local comment = require("mini.comment")

local comment_strings = {
  default = {
    html = "<!-- %s -->",
    cf = "<!-- %s -->",
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
