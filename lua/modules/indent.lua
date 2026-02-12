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

  -- Initial draw
  H.auto_draw()
end

-- Defaults --------------------------------------------------------------------
ModIndent.config = {
  draw = {
    -- Delay (ms) between event and drawing.
    delay = 10,

    predicate = nil,

    -- Extmark priority (higher draws on top)
    priority = 10,

    -- If true, only render when window has :set list
    respect_list = false,
  },

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
  H.clear_all_ns()
  H.stop_all_timers()
end

ModIndent.toggle = function()
  if H.is_disabled() then
    ModIndent.enable()
  else
    ModIndent.disable()
  end
end

ModIndent.render = function(win)
  win = win or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then return end
  local buf = vim.api.nvim_win_get_buf(win)
  H.render_visible(buf, win)
end

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModIndent.config)

H.ns_id = vim.api.nvim_create_namespace("ModIndent")

H.cache = {
  pending = {},

  current = {
    event_id = 0,
    last_key_by_win = {}, -- win -> string key
  },
}

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("draw", config.draw, "table")
  H.check_type("draw.delay", config.draw.delay, "number")
  H.check_type("draw.predicate", config.draw.predicate, "function", true)
  H.check_type("draw.priority", config.draw.priority, "number")
  H.check_type("draw.respect_list", config.draw.respect_list, "boolean")

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

  local enter_events = { "BufWinEnter", "WinEnter" }
  au(enter_events, "*", function() H.auto_draw() end, "Auto draw (enter)")

  au("OptionSet", { "shiftwidth", "tabstop", "expandtab" }, function() H.auto_draw() end, "Auto draw (options)")

  au("ColorScheme", "*", H.create_default_hl, "Ensure colors")

  au("BufWipeout", "*", function(args)
    H.clear_ns(args.buf)
    for win, key in pairs(H.cache.current.last_key_by_win) do
      if type(key) == "string" and key:find("^" .. tostring(args.buf) .. ":", 1, true) then
        H.cache.current.last_key_by_win[win] = nil
      end
    end
  end, "Clear ns")
end

H.create_default_hl = function() vim.api.nvim_set_hl(0, "ModIndentSymbol", { default = true, link = "NonText" }) end

H.is_disabled = function() return vim.g.modindent_disable == true or vim.b.modindent_disable == true end

H.get_config = function(config)
  return vim.tbl_deep_extend("force", ModIndent.config, vim.b.modindent_config or {}, config or {})
end

-- Indents ---------------------------------------------------------------------

--- Return the effective indent “step” (in screen columns) for a buffer.
--- Uses `shiftwidth` when it’s > 0, otherwise falls back to `tabstop`.
---@param buf_id number|nil Buffer handle (0 = current)
---@return number indent_step Columns per indent level
H.get_indent_step = function(buf_id)
  buf_id = buf_id or 0
  if vim.bo[buf_id].shiftwidth > 0 then return vim.bo[buf_id].shiftwidth end
  return vim.bo[buf_id].tabstop
end

--- Get a line's indent in screen columns (tab-aware), using `indent()`.
--- Line numbers are 1-indexed.
---@param buf number|nil Buffer handle (0 = current)
---@param lnum number Line number (1-indexed)
---@return number indent_cols Indent in screen columns (0 if invalid/out of range)
H.get_line_indent_cols = function(buf, lnum)
  buf = buf or 0
  if lnum < 1 then return 0 end
  if not vim.api.nvim_buf_is_valid(buf) then return 0 end
  if lnum > vim.api.nvim_buf_line_count(buf) then return 0 end

  local cur = vim.api.nvim_get_current_buf()
  if buf ~= cur then
    return vim.api.nvim_buf_call(buf, function() return vim.fn.indent(lnum) end)
  end
  return vim.fn.indent(lnum)
end

--- Check if a line is blank (only whitespace).
---@param buf number
---@param lnum number
---@return boolean
H.is_blank_line = function(buf, lnum)
  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
  return line:match("^%s*$") ~= nil
end

--- Get indent (screen columns) of the previous non-blank line.
--- Returns 0 if none found.
---@param buf number
---@param lnum number
---@return number indent_cols
H.prev_nonblank_indent_cols = function(buf, lnum)
  for i = lnum - 1, 1, -1 do
    if not H.is_blank_line(buf, i) then return H.get_line_indent_cols(buf, i) end
  end
  return 0
end

--- Get indent (screen columns) of the next non-blank line.
--- Returns 0 if none found.
---@param buf number
---@param lnum number
---@return number indent_cols
H.next_nonblank_indent_cols = function(buf, lnum)
  local last = vim.api.nvim_buf_line_count(buf)
  for i = lnum + 1, last do
    if not H.is_blank_line(buf, i) then return H.get_line_indent_cols(buf, i) end
  end
  return 0
end

--- Get effective indent for a line.
--- For non-blank lines: its own indent.
--- For blank lines: minimum of previous and next non-blank indents.
---@param buf number
---@param lnum number
---@return number indent_cols
H.get_effective_indent_cols = function(buf, lnum)
  if not H.is_blank_line(buf, lnum) then return H.get_line_indent_cols(buf, lnum) end

  local prev = H.prev_nonblank_indent_cols(buf, lnum)
  local next = H.next_nonblank_indent_cols(buf, lnum)
  return math.min(prev, next)
end

---@param buf number
---@param lnum number
---@return number[] cols
H.get_guide_cols_for_line = function(buf, lnum)
  local step = H.get_indent_step(buf)
  if step <= 0 then return {} end

  local indent_cols = H.get_effective_indent_cols(buf, lnum)
  if indent_cols <= 0 then return {} end

  local cols = {}
  local col = 0
  while col < indent_cols do
    cols[#cols + 1] = col
    col = col + step
  end

  return cols
end

-- Rendering -------------------------------------------------------------------

--- Decide whether indent guides should render for a given buffer/window.
--- Applies hard defaults (valid buf/win, same buf in win, normal buftype, non-float),
--- then config-based checks.
---@param buf number
---@param win number
---@return boolean
H.should_render = function(buf, win)
  if H.is_disabled() then return false end
  if not vim.api.nvim_buf_is_valid(buf) then return false end
  if not vim.api.nvim_win_is_valid(win) then return false end
  if vim.api.nvim_win_get_buf(win) ~= buf then return false end

  -- hard defaults
  if vim.bo[buf].buftype ~= "" then return false end

  local wcfg = vim.api.nvim_win_get_config(win)
  if wcfg and wcfg.relative ~= "" then return false end

  local cfg = H.get_config()

  if cfg.draw.respect_list and not vim.wo[win].list then return false end

  -- user predicate is only for extra filtering
  if cfg.draw.predicate and not cfg.draw.predicate(buf, win) then return false end

  return true
end

--- Build a stable cache key representing the current render-relevant state
--- for a window/buffer view.
---@param buf number
---@param win number
---@return string
H.make_render_key = function(buf, win)
  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)
  local leftcol = vim.fn.winsaveview().leftcol or 0

  local sw = vim.bo[buf].shiftwidth or 0
  local ts = vim.bo[buf].tabstop or 0
  local et = vim.bo[buf].expandtab and 1 or 0
  local list = vim.wo[win].list and 1 or 0

  -- NOTE: all must be strings/numbers, no nils
  return table.concat({
    tostring(buf),
    tostring(top),
    tostring(bot),
    tostring(leftcol),
    tostring(sw),
    tostring(ts),
    tostring(et),
    tostring(list),
  }, ":")
end

--- Cache guard for rendering: returns true if view changed since last draw.
---@param buf number
---@param win number
---@return boolean should_draw
H.cache_render = function(buf, win)
  local key = H.make_render_key(buf, win)
  if H.cache.current.last_key_by_win[win] == key then return false end
  H.cache.current.last_key_by_win[win] = key
  return true
end

--- Render indent guide symbols for a single line.
---@param buf number
---@param lnum number
---@return nil
H.render_line = function(buf, lnum)
  vim.api.nvim_buf_clear_namespace(buf, H.ns_id, lnum - 1, lnum)

  local cols = H.get_guide_cols_for_line(buf, lnum)
  if #cols == 0 then return end

  local indent_cols = H.get_effective_indent_cols(buf, lnum)
  if indent_cols <= 0 then return end

  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
  local cfg = H.get_config()

  local symbol = cfg.symbol or "│"
  local prio = cfg.draw.priority or 10

  for _, col in ipairs(cols) do
    if col < indent_cols then
      local byte = line:sub(col + 1, col + 1)
      if H.is_blank_line(buf, lnum) or byte == " " or byte == "\t" or byte == "" then
        vim.api.nvim_buf_set_extmark(buf, H.ns_id, lnum - 1, 0, {
          hl_mode = "combine",
          priority = prio,
          virt_text = { { symbol, "ModIndentSymbol" } },
          virt_text_pos = "overlay",
          virt_text_win_col = col,
        })
      end
    end
  end
end

--- Render indent guides for the currently visible lines in a window.
---@param buf number
---@param win number
---@return nil
H.render_visible = function(buf, win)
  if not H.should_render(buf, win) then return end

  local top = vim.fn.line("w0", win)
  local bot = vim.fn.line("w$", win)

  vim.api.nvim_buf_clear_namespace(buf, H.ns_id, top - 1, bot)

  for lnum = top, bot do
    H.render_line(buf, lnum)
  end
end

--- Clear ModIndent extmarks for a single buffer.
---@param buf_id number|nil
---@return nil
H.clear_ns = function(buf_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf_id) then return end
  vim.api.nvim_buf_clear_namespace(buf_id, H.ns_id, 0, -1)
end

--- Clear ModIndent extmarks for all valid buffers.
---@return nil
H.clear_all_ns = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then H.clear_ns(buf) end
  end
end

--- Render indent guides for all visible windows.
---@return nil
H.render_all_visible = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if H.should_render(buf, win) then H.render_visible(buf, win) end
    end
  end
end

--- Stop and clear all pending debounce timers.
---@return nil
H.stop_all_timers = function()
  for k, t in pairs(H.cache.pending) do
    if t and not t:is_closing() then
      t:stop()
      t:close()
    end
    H.cache.pending[k] = nil
  end
end

--- Auto-render indent guides in the current window.
--- Uses a cached render key to skip work on "lazy" events (cursor/mode moves),
--- and uses an event id to prevent out-of-order deferred draws.
---@param opts table|nil { lazy?: boolean }
---@return nil
H.auto_draw = function(opts)
  opts = opts or {}

  if H.is_disabled() then
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      pcall(vim.api.nvim_buf_clear_namespace, buf, H.ns_id, 0, -1)
      H.cache.current.last_key_by_win[win] = nil
    end
    return
  end

  local win = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then return end
  local buf = vim.api.nvim_win_get_buf(win)
  if not H.should_render(buf, win) then return end

  if opts.lazy and not H.cache_render(buf, win) then return end

  H.cache.current.event_id = H.cache.current.event_id + 1
  local local_event_id = H.cache.current.event_id

  local delay = H.get_config().draw.delay or 0
  vim.defer_fn(function()
    if H.cache.current.event_id ~= local_event_id then return end
    if H.is_disabled() then return end
    if not vim.api.nvim_win_is_valid(win) then return end
    if vim.api.nvim_win_get_buf(win) ~= buf then return end
    H.render_visible(buf, win)
  end, delay)
end

--- Schedule a (debounced) render for a window.
--- Safe to call from autocmd callbacks that might pass an args table.
---@param win number|table|nil Window id (or autocmd args table; will fall back to current win)
---@param ms number|nil Debounce delay in milliseconds (defaults to config.draw.delay)
---@return nil
H.schedule_render = function(win, ms)
  -- Autocmd callbacks sometimes pass an args table; normalize.
  if type(win) ~= "number" then win = vim.api.nvim_get_current_win() end
  win = win or vim.api.nvim_get_current_win()

  ms = ms or (H.get_config().draw.delay or 0)

  if not vim.api.nvim_win_is_valid(win) then return end
  if H.is_disabled() then return end

  H.debounce(H.cache.pending, win, ms, function()
    if H.is_disabled() then return end
    if not vim.api.nvim_win_is_valid(win) then return end
    local buf = vim.api.nvim_win_get_buf(win)
    H.render_visible(buf, win)
  end)
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(mod.indent) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.debounce = function(cache, key, ms, fn)
  if not cache or not key or not fn then return end

  local old = cache[key]
  if old and not old:is_closing() then
    old:stop()
    old:close()
  end

  local timer = vim.uv.new_timer()
  if not timer then return end

  cache[key] = timer

  timer:start(
    ms,
    0,
    vim.schedule_wrap(function()
      if timer and not timer:is_closing() then
        timer:stop()
        timer:close()
      end
      cache[key] = nil
      fn()
    end)
  )
end

return ModIndent
