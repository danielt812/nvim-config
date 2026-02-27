-- #############################################################################
-- #                               Winbar Module                               #
-- #############################################################################

-- Module definition -----------------------------------------------------------
local ModWinbar = {}
local H = {}

ModWinbar.setup = function(config)
  -- Export module
  _G.ModWinbar = ModWinbar

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)

  -- Define behavior
  H.create_autocommands()

  -- Create default highlighting
  H.create_default_hl()
end

-- Defaults --------------------------------------------------------------------
ModWinbar.config = {
  winbar = {
    icons = true,
    alt_icons = false,
    separator = " > ",
    max_depth = 5,
    always_show = true,
  },

  -- Per-kind icon overrides: { [kind_name] = "glyph" }
  -- Overrides whichever preset is active. Empty by default.
  icons = {},
}

-- ModWinbar functionality --------------------------------------------------------
--- Enable the winbar for a buffer.
--- @param bufnr? integer Buffer handle, defaults to current buffer.
ModWinbar.enable = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.b[bufnr].modwinbar_disable = false
end

--- Disable the winbar for a buffer and clear it from all windows showing that buffer.
--- @param bufnr? integer Buffer handle, defaults to current buffer.
ModWinbar.disable = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.b[bufnr].modwinbar_disable = true
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.wo[winid].winbar = ""
  end
end

--- Toggle the winbar on or off for a buffer.
--- @param bufnr? integer Buffer handle, defaults to current buffer.
ModWinbar.toggle = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.b[bufnr].modwinbar_disable then
    ModWinbar.enable(bufnr)
  else
    ModWinbar.disable(bufnr)
  end
end

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModWinbar.config)

H.cache = {}

-- stylua: ignore start
H.kinds = {
  [1]  = { name = "file",          hl = "ModWinbarFile",          default = "", alt = "󰈙" },
  [2]  = { name = "module",        hl = "ModWinbarModule",        default = "", alt = "" },
  [3]  = { name = "namespace",     hl = "ModWinbarNamespace",     default = "", alt = "" },
  [4]  = { name = "package",       hl = "ModWinbarPackage",       default = "", alt = "󰉋" },
  [5]  = { name = "class",         hl = "ModWinbarClass",         default = "", alt = "󰠱" },
  [6]  = { name = "method",        hl = "ModWinbarMethod",        default = "", alt = "󰆧" },
  [7]  = { name = "property",      hl = "ModWinbarProperty",      default = "", alt = "󰜢" },
  [8]  = { name = "field",         hl = "ModWinbarField",         default = "", alt = "󰜢" },
  [9]  = { name = "constructor",   hl = "ModWinbarConstructor",   default = "", alt = "" },
  [10] = { name = "enum",          hl = "ModWinbarEnum",          default = "", alt = "" },
  [11] = { name = "interface",     hl = "ModWinbarInterface",     default = "", alt = "" },
  [12] = { name = "function",      hl = "ModWinbarFunction",      default = "", alt = "󰊕" },
  [13] = { name = "variable",      hl = "ModWinbarVariable",      default = "", alt = "󰀫" },
  [14] = { name = "constant",      hl = "ModWinbarConstant",      default = "", alt = "󰏿" },
  [15] = { name = "string",        hl = "ModWinbarString",        default = "", alt = "󰉿" },
  [16] = { name = "number",        hl = "ModWinbarNumber",        default = "", alt = "󰎠" },
  [17] = { name = "boolean",       hl = "ModWinbarBoolean",       default = "", alt = "󰎠" },
  [18] = { name = "array",         hl = "ModWinbarArray",         default = "", alt = "" },
  [19] = { name = "object",        hl = "ModWinbarObject",        default = "", alt = "" },
  [20] = { name = "key",           hl = "ModWinbarKey",           default = "", alt = "󰌋" },
  [21] = { name = "null",          hl = "ModWinbarNull",          default = "", alt = "󰏘" },
  [22] = { name = "enummember",    hl = "ModWinbarEnumMember",    default = "", alt = "" },
  [23] = { name = "struct",        hl = "ModWinbarStruct",        default = "", alt = "󰙅" },
  [24] = { name = "event",         hl = "ModWinbarEvent",         default = "", alt = "" },
  [25] = { name = "operator",      hl = "ModWinbarOperator",      default = "", alt = "󰆕" },
  [26] = { name = "typeparameter", hl = "ModWinbarTypeParameter", default = "", alt = "󰊄" },
}
-- stylua: ignore end

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("winbar", config.winbar, "table")
  H.check_type("winbar.separator", config.winbar.separator, "string")
  H.check_type("winbar.icons", config.winbar.icons, "boolean")
  H.check_type("winbar.alt_icons", config.winbar.alt_icons, "boolean")
  H.check_type("winbar.max_depth", config.winbar.max_depth, "number")
  H.check_type("winbar.always_show", config.winbar.always_show, "boolean")

  H.check_type("icons", config.icons, "table")

  return config
end

H.apply_config = function(config) ModWinbar.config = config end

H.create_autocommands = function()
  H.group = vim.api.nvim_create_augroup("ModWinbar", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = H.group, pattern = pattern, callback = callback, desc = desc })
  end

  au("LspAttach", "*", H.on_lsp_attach, "Check for documentSymbol support on LSP attach")

  au("CursorMoved", "*", H.on_cursor_moved, "Update winbar symbol path on cursor move")
end

H.create_default_hl = function()
  -- stylua: ignore start
  vim.api.nvim_set_hl(0, "ModWinbarSeparator",     { link = "SpecialKey", default = true })
  vim.api.nvim_set_hl(0, "ModWinbarFile",          { link = "Normal",     default = true })
  vim.api.nvim_set_hl(0, "ModWinbarModule",        { link = "Include",    default = true })
  vim.api.nvim_set_hl(0, "ModWinbarNamespace",     { link = "Include",    default = true })
  vim.api.nvim_set_hl(0, "ModWinbarPackage",       { link = "Include",    default = true })
  vim.api.nvim_set_hl(0, "ModWinbarClass",         { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarMethod",        { link = "Function",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarProperty",      { link = "Identifier", default = true })
  vim.api.nvim_set_hl(0, "ModWinbarField",         { link = "Identifier", default = true })
  vim.api.nvim_set_hl(0, "ModWinbarConstructor",   { link = "Function",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarEnum",          { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarInterface",     { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarFunction",      { link = "Function",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarVariable",      { link = "Identifier", default = true })
  vim.api.nvim_set_hl(0, "ModWinbarConstant",      { link = "Constant",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarString",        { link = "String",     default = true })
  vim.api.nvim_set_hl(0, "ModWinbarNumber",        { link = "Number",     default = true })
  vim.api.nvim_set_hl(0, "ModWinbarBoolean",       { link = "Boolean",    default = true })
  vim.api.nvim_set_hl(0, "ModWinbarArray",         { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarObject",        { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarKey",           { link = "Identifier", default = true })
  vim.api.nvim_set_hl(0, "ModWinbarNull",          { link = "Special",    default = true })
  vim.api.nvim_set_hl(0, "ModWinbarEnumMember",    { link = "Constant",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarStruct",        { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarEvent",         { link = "Type",       default = true })
  vim.api.nvim_set_hl(0, "ModWinbarOperator",      { link = "Operator",   default = true })
  vim.api.nvim_set_hl(0, "ModWinbarTypeParameter", { link = "Type",       default = true })
  -- stylua: ignore end
end

H.is_disabled = function() return vim.g.modwinbar_disable == true or vim.b.modwinbar_disable == true end

H.get_config = function(config)
  return vim.tbl_deep_extend("force", ModWinbar.config, vim.b.modwinbar_config or {}, config or {})
end

-- Autocommands ----------------------------------------------------------------
H.on_lsp_attach = function(args)
  if H.is_disabled() then return end
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end

  if not client.server_capabilities.documentSymbolProvider then return end
  local bufnr = args.buf

  local supports_document_symbol = client:supports_method("textDocument/documentSymbol", bufnr)

  if supports_document_symbol then
    H.cache[bufnr] = H.cache[bufnr] or {}
    H.cache[bufnr].has_document_symbol = true
    H.cache[bufnr].enabled = true
    for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
      vim.wo[winid].winbar = ""
    end
  end
end

H.on_cursor_moved = function(args)
  local bufnr = args.buf
  if not H.cache[bufnr] or not H.cache[bufnr].enabled then return end
  if H.is_disabled() then return end

  -- Cancel any in-flight request before firing a new one
  if H.cache[bufnr].cancel_request then
    H.cache[bufnr].cancel_request()
    H.cache[bufnr].cancel_request = nil
  end

  local winid = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local row, col = cursor[1] - 1, cursor[2]

  local lsp_callback = function(err, result)
    H.cache[bufnr].cancel_request = nil
    if err or not result or #result == 0 then
      H.cache[bufnr].symbol_path = {}
      vim.wo[winid].winbar = H.get_config().winbar.always_show and " " or ""
      return
    end
    H.cache[bufnr].symbol_path = H.find_symbols_at_pos(result, row, col)
    vim.wo[winid].winbar = H.render(H.cache[bufnr].symbol_path)
  end

  local _, cancel = vim.lsp.buf_request(
    bufnr,
    "textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
    lsp_callback
  )
  H.cache[bufnr].cancel_request = cancel
end

-- Rendering -------------------------------------------------------------------
H.render = function(symbol_path)
  if not symbol_path or #symbol_path == 0 then return H.get_config().winbar.always_show and " " or "" end

  local depth = H.get_config().winbar.max_depth
  if #symbol_path > depth then symbol_path = vim.list_slice(symbol_path, #symbol_path - depth + 1) end

  local parts = {}

  local preset_key = H.get_config().winbar.alt_icons and "alt" or "default"

  for _, symbol in ipairs(symbol_path) do
    local kind = H.kinds[symbol.kind]
    local icon, hl

    if H.get_config().winbar.icons and kind then
      icon = H.get_config().icons[kind.name] or kind[preset_key]
      hl = kind.hl
    end

    if icon and hl then
      table.insert(parts, "%#" .. hl .. "#" .. icon .. "%* " .. symbol.name)
    else
      table.insert(parts, symbol.name)
    end
  end

  local separator = "%#ModWinbarSeparator#" .. H.get_config().winbar.separator .. "%*"
  return " " .. table.concat(parts, separator)
end

H.pos_in_range = function(range, row, col)
  if not range or not range.start or not range["end"] then return false end
  if row < range.start.line or row > range["end"].line then return false end
  if row == range.start.line and col < range.start.character then return false end
  if row == range["end"].line and col > range["end"].character then return false end
  return true
end

H.find_symbols_at_pos = function(symbols, row, col)
  -- SymbolInformation (flat list) vs DocumentSymbol (tree)
  if #symbols > 0 and not symbols[1].range then
    return H.find_flat_symbols_at_pos(symbols, row, col)
  end

  -- DocumentSymbol: recursive tree traversal
  local path = {}
  for _, symbol in ipairs(symbols) do
    if H.pos_in_range(symbol.range, row, col) then
      table.insert(path, symbol)
      if symbol.children then vim.list_extend(path, H.find_symbols_at_pos(symbol.children, row, col)) end
      return path
    end
  end
  return path
end

H.find_flat_symbols_at_pos = function(symbols, row, col)
  local matches = {}
  for _, symbol in ipairs(symbols) do
    local range = symbol.location and symbol.location.range
    if H.pos_in_range(range, row, col) then
      table.insert(matches, symbol)
    end
  end
  table.sort(matches, function(a, b)
    local ra, rb = a.location.range, b.location.range
    if ra.start.line ~= rb.start.line then return ra.start.line < rb.start.line end
    if ra.start.character ~= rb.start.character then return ra.start.character < rb.start.character end
    if ra["end"].line ~= rb["end"].line then return ra["end"].line > rb["end"].line end
    return ra["end"].character > rb["end"].character
  end)
  return matches
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(mod.winbar) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

return ModWinbar
