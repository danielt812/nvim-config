--- Statusline UI components
---
--- All components:
--- - return a string (or "" when inactive)
--- - accept an optional `opts` table
--- - support padding via `opts.pad`
---
--- Common options shared by all components.
--- @class ComponentOpts
--- @field icon? string|boolean   Icon override or enable default icon
--- @field text? string|boolean   Text override or enable default text
--- @field pad? '"left"'|'"right"'|'"both"' Padding direction
--- @field format? string         Date/time format (when supported)
--- @field horizontal? boolean    Horizontal progress bar (progressbar only)
local M = {}
local H = {}

-- stylua: ignore start
-- ───────────────────────────────────────────────────────────────
-- Helpers
-- ───────────────────────────────────────────────────────────────

--- Apply optional padding to a component.
--- @param text string
--- @param opts ComponentOpts?
--- @return string
H.pad = function(text, opts)
  opts = opts or {}
  if text == "" then
    return ""
  end
  if opts.pad == "both" then
    return " " .. text .. " "
  elseif opts.pad == "left" then
    return " " .. text
  elseif opts.pad == "right" then
    return text .. " "
  end
  return text
end

--- Resolve icon option.
--- @param opts ComponentOpts?
--- @param default string
--- @return string
H.resolve_icon = function(opts, default)
  opts = opts or {}

  if type(opts.icon) == "string" then
    return opts.icon
  end

  if opts.icon == true then
    return default
  end

  return ""
end

--- Resolve text option.
--- @param opts ComponentOpts?
--- @param default string
--- @return string
H.resolve_text = function(opts, default)
  opts = opts or {}

  if type(opts.text) == "string" then
    return opts.text
  end

  if opts.text == true then
    return default
  end

  return ""
end

--- Check if a mini.nvim module is disabled.
--- @param module string
--- @return boolean
H.mod_disabled = function(module)
  local key = "mini" .. module .. "_disable"
  return vim.b[key] or vim.g[key]
end

--- Generic mini.nvim disabled indicator.
--- @param module string
--- @param icon string
--- @param label string
--- @param opts ComponentOpts?
--- @return string
H.mini_indicator = function(module, icon, label, opts)
  opts = opts or {}
  if not H.mod_disabled(module) then return "" end
  if opts.text == false then return H.pad(icon, opts) end
  return H.pad(icon .. " " .. label, opts)
end

-- ───────────────────────────────────────────────────────────────
-- Core components
-- ───────────────────────────────────────────────────────────────

--- Date component.
--- @param opts ComponentOpts?
--- @return string
M.date = function(opts)
  opts = opts or {}
  local icon = H.resolve_icon(opts, " ")
  local text = opts.text or "%Y-%m-%d"
  return H.pad(icon .. os.date(text), opts)
end

--- Cursor location (line:column).
--- @param opts ComponentOpts?
--- @return string
M.location = function(opts)
  opts = opts or {}
  local icon = H.resolve_icon(opts, " ")
  local text = H.resolve_text(opts, string.format("%d:%d", vim.fn.line("."), vim.fn.col(".")))
  return H.pad(icon .. text, opts)
end

--- Progress bar based on cursor position.
--- @param opts ComponentOpts?
--- @return string
M.progressbar = function(opts)
  opts = opts or {}
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local total = vim.fn.line("$")
  if total == 0 then return chars[1] end
  local idx = math.ceil((vim.fn.line(".") / total) * #chars)
  idx = math.min(math.max(idx, 1), #chars)
  return H.pad(chars[idx], opts)
end

--- Read-only indicator.
--- @param opts ComponentOpts?
--- @return string
M.readonly = function(opts)
  opts = opts or {}
  if not vim.bo.readonly then return "" end
  local icon = H.resolve_icon(opts, " ")
  local text = H.resolve_text(opts, "RO")
  return H.pad(icon .. text, opts)
end

--- Shiftwidth value.
--- @param opts ComponentOpts?
--- @return string
M.shiftwidth = function(opts)
  opts = opts or {}
  local icon = H.resolve_icon(opts, "󰌒 ")
  return H.pad(icon .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 }), opts)
end

--- Spell-check indicator.
--- @param opts ComponentOpts?
--- @return string
M.spell = function(opts)
  opts = opts or {}
  if not vim.wo.spell then return "" end
  local icon = H.resolve_icon(opts, "󰓆 ")
  local text = H.resolve_text(opts, "spell")
  return H.pad(icon .. text, opts)
end

--- Time component.
--- @param opts ComponentOpts?
--- @return string
M.time = function(opts)
  opts = opts or {}
  local icon = H.resolve_icon(opts, " ")
  local text = opts.text or "%H:%M"
  return H.pad(icon .. os.date(text), opts)
end

-- ───────────────────────────────────────────────────────────────
-- Mini.nvim disabled indicators
-- ───────────────────────────────────────────────────────────────

M.animation = function(opts) return H.mini_indicator("animation", H.resolve_icon(opts, "󰪏"), H.resolve_text(opts, "[A]"), opts) end
M.cursorword = function(opts) return H.mini_indicator("cursorword", H.resolve_icon(opts, "󰈇"), H.resolve_text(opts, "[CW]"), opts) end
M.indentscope = function(opts) return H.mini_indicator("indentscope", H.resolve_icon(opts, ""), H.resolve_text(opts, "[IS]"), opts) end
M.hipatterns = function(opts) return H.mini_indicator("hipatterns", H.resolve_icon(opts, ""), H.resolve_text(opts, "[HP]"), opts) end
M.pairs = function(opts) return H.mini_indicator("pairs", H.resolve_icon(opts, "󰅪"), H.resolve_text(opts, "[P]"), opts) end

return M
-- stylua: ignore end
