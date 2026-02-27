-- #############################################################################
-- #                               Indent Module                               #
-- #############################################################################

-- Module definition -----------------------------------------------------------
local ModIndent = {}
local H = {}

ModIndent.setup = function(config)
  -- Export module
  _G.ModIndent = ModIndent

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
ModIndent.config = {
  draw = {
    predicate = nil,

    -- Extmark priority (higher draws on top)
    priority = 1,
  },

  -- Don't place ext mark over tab listchar
  show_tabs = true,

  -- Which character to use for drawing guides
  symbol = "│",
}

-- ModIndent functionality -----------------------------------------------------
ModIndent.enable = function()
  vim.g.modindent_disable = false
  vim.b.modindent_disable = nil
  H.auto_draw()
end

ModIndent.disable = function()
  vim.g.modindent_disable = true
  H.clear_ns()
end

ModIndent.toggle = function()
  if H.is_disabled() then
    ModIndent.enable()
  else
    ModIndent.disable()
  end
end

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModIndent.config)

H.ns_id = vim.api.nvim_create_namespace("ModIndent")

H.cache = {}

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("draw", config.draw, "table")
  H.check_type("draw.predicate", config.draw.predicate, "function", true)
  H.check_type("draw.priority", config.draw.priority, "number")

  H.check_type("show_tabs", config.show_tabs, "boolean")
  H.check_type("symbol", config.symbol, "string")

  return config
end

H.apply_config = function(config) ModIndent.config = config end

H.create_autocommands = function()
  local group = vim.api.nvim_create_augroup("ModIndent", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end

  local lazy_events = { "CursorMoved", "CursorMovedI", "ModeChanged" }
  au(lazy_events, "*", function() H.auto_draw({ lazy = true }) end, "Auto draw (lazy)")

  local now_events = { "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }
  au(now_events, "*", function() H.auto_draw() end, "Auto draw (now)")

  au("OptionSet", { "shiftwidth", "tabstop", "expandtab" }, function() H.auto_draw() end, "Auto draw (options)")

  au("ColorScheme", "*", H.create_default_hl, "Ensure colors")
end

H.create_default_hl = function() vim.api.nvim_set_hl(0, "ModIndentSymbol", { default = true, link = "NonText" }) end

H.is_disabled = function() return vim.g.modindent_disable == true or vim.b.modindent_disable == true end

H.get_config = function(config)
  return vim.tbl_deep_extend("force", ModIndent.config, vim.b.modindent_config or {}, config or {})
end

H.make_view_key = function(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)
  local leftcol = (vim.fn.winsaveview().leftcol or 0)
  return table.concat({ buf, top, bot, leftcol }, ":")
end

-- Indents ---------------------------------------------------------------------

H.get_indent_step = function(buf_id)
  buf_id = buf_id or 0
  if vim.bo[buf_id].shiftwidth > 0 then
    return vim.bo[buf_id].shiftwidth
  else
    return vim.bo[buf_id].tabstop
  end
end

H.get_effective_indent_cols = function(buf, lnum)
  return vim.api.nvim_buf_call(buf, function()
    local line = vim.fn.getline(lnum)
    if line:match("^%s*$") == nil then return vim.fn.indent(lnum) end

    local prev = vim.fn.prevnonblank(lnum)
    local next = vim.fn.nextnonblank(lnum)

    local prev_indent = (prev > 0) and vim.fn.indent(prev) or 0
    local next_indent = (next > 0) and vim.fn.indent(next) or 0

    return math.min(prev_indent, next_indent)
  end)
end

H.get_guide_cols_for_line = function(buf, lnum)
  local step = H.get_indent_step(buf)
  if step <= 0 then return {} end

  local indent_cols = H.get_effective_indent_cols(buf, lnum)
  if indent_cols <= 0 then return {} end

  local cols = {}
  for col = 0, indent_cols - 1, step do
    cols[#cols + 1] = col
  end
  return cols
end

-- Rendering -------------------------------------------------------------------

H.should_render = function(buf, win)
  if H.is_disabled() then return false end
  if not vim.api.nvim_buf_is_valid(buf) then return false end
  if not vim.api.nvim_win_is_valid(win) then return false end
  if vim.api.nvim_win_get_buf(win) ~= buf then return false end
  if vim.bo[buf].buftype ~= "" then return false end

  local wcfg = vim.api.nvim_win_get_config(win)
  if wcfg and wcfg.relative ~= "" then return false end

  -- User predicate is only for extra filtering
  if H.get_config().draw.predicate and not H.get_config().draw.predicate(buf, win) then return false end

  return true
end

H.render_line = function(buf, lnum, leftcol)
  local cols = H.get_guide_cols_for_line(buf, lnum)
  if #cols == 0 then return end

  local indent_cols = H.get_effective_indent_cols(buf, lnum)
  if indent_cols <= 0 then return end

  local line = vim.fn.getline(lnum)
  local symbol = H.get_config().symbol
  local priority = H.get_config().draw.priority
  local show_tabs = H.get_config().show_tabs

  local is_blank = line:match("^%s*$") ~= nil
  leftcol = leftcol or 0

  for _, col in ipairs(cols) do
    if col < indent_cols then
      local win_col = col - leftcol
      if win_col >= 0 then
        local ch = line:sub(col + 1, col + 1)

        local ok = is_blank or ch == " " or (show_tabs and ch == "\t")

        if ok then
          vim.api.nvim_buf_set_extmark(buf, H.ns_id, lnum - 1, 0, {
            hl_mode = "combine",
            priority = priority,
            virt_text = { { symbol, "ModIndentSymbol" } },
            virt_text_pos = "overlay",
            virt_text_win_col = win_col,
            virt_text_repeat_linebreak = true,
          })
        end
      end
    end
  end
end

H.render = function(buf, win)
  if not H.should_render(buf, win) then return end

  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)
  local view = vim.fn.winsaveview()

  vim.api.nvim_buf_clear_namespace(buf, H.ns_id, top - 1, bot)

  for lnum = top, bot do
    H.render_line(buf, lnum, view.leftcol)
  end
end

H.clear_ns = function(buf_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf_id) then return end
  vim.api.nvim_buf_clear_namespace(buf_id, H.ns_id, 0, -1)
end

H.auto_draw = function(opts)
  opts = opts or {}

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  if not H.should_render(buf, win) then return end

  if opts.lazy then
    local key = H.make_view_key(win)
    if H.cache[win] == key then return end
    H.cache[win] = key
  end

  H.render(buf, win)
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(mod.indent) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

return ModIndent
