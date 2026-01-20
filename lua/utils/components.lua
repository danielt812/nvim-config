--- Statusline UI components
---
--- All components:
--- - return a string (or "" when inactive)
--- - accept an optional `opts` table
--- - support padding via `opts.pad`
---
--- Common options:
--- @class ComponentOpts
--- @field icon? boolean   Show leading icon
--- @field pad? '"left"'|'"right"'|'"both"' Padding direction
--- @field format? string Date/time format (when supported)
--- @field horizontal? boolean Horizontal progress bar (progressbar only)
local M = {}
local H = {}

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

--- Date component.
--- @param opts ComponentOpts?
--- @return string
M.date = function(opts)
  opts = opts or {}
  local fmt = opts.format or "%Y-%m-%d"
  local icon = opts.icon and " " or ""
  return H.pad(icon .. os.date(fmt), opts)
end

--- File encoding component.
--- @param opts ComponentOpts?
--- @return string
M.encoding = function(opts)
  opts = opts or {}
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local icon = opts.icon and "󰧮 " or ""
  return H.pad(icon .. encoding, opts)
end

--- Indent style (spaces or tabs).
--- @param opts ComponentOpts?
--- @return string
M.indent = function(opts)
  opts = opts or {}
  local icon = opts.icon and "󰉵 " or ""
  local style = vim.bo.expandtab and "spaces" or "tabs"
  return H.pad(icon .. style, opts)
end

--- Cursor location (line:column).
--- @param opts ComponentOpts?
--- @return string
M.location = function(opts)
  opts = opts or {}
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local icon = opts.icon and " " or ""
  return H.pad(icon .. string.format("%d:%d", line, col), opts)
end

--- Cursor position as percentage of file.
--- @param opts ComponentOpts?
--- @return string
M.percent = function(opts)
  opts = opts or {}
  local total = vim.fn.line("$")
  if total == 0 then
    return ""
  end
  local pct = math.floor(vim.fn.line(".") / total * 100)
  local icon = opts.icon and " " or ""
  return H.pad(pct .. icon, opts)
end

--- Progress bar based on cursor position.
--- @param opts ComponentOpts?
--- @return string
M.progressbar = function(opts)
  opts = opts or {}
  local vertical = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local horizontal = { "▏", "▎", "▍", "▌", "▋", "▊", "▉", "█" }

  local chars = opts.horizontal and horizontal or vertical
  local total = vim.fn.line("$")

  if total == 0 then
    return chars[1]
  end

  local current = vim.fn.line(".")
  local ratio = current / total
  local index = math.ceil(ratio * #chars)
  index = math.min(math.max(index, 1), #chars)

  return H.pad(chars[index], opts)
end

--- Read-only indicator.
--- @param opts ComponentOpts?
--- @return string
M.readonly = function(opts)
  opts = opts or {}
  if not vim.bo.readonly then
    return ""
  end
  local icon = opts.icon and " " or ""
  return H.pad(icon .. "RO", opts)
end

--- Shiftwidth value.
--- @param opts ComponentOpts?
--- @return string
M.shiftwidth = function(opts)
  opts = opts or {}
  local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
  local icon = opts.icon and "󰌒 " or ""
  return H.pad(icon .. shiftwidth, opts)
end

--- Spell-check indicator.
--- @param opts ComponentOpts?
--- @return string
M.spell = function(opts)
  opts = opts or {}
  if not vim.wo.spell then
    return ""
  end
  local icon = opts.icon and "󰓆 " or ""
  return H.pad(icon, opts)
end

--- Time component.
--- @param opts ComponentOpts?
--- @return string
M.time = function(opts)
  opts = opts or {}
  local fmt = opts.format or "%H:%M"
  local icon = opts.icon and " " or ""
  return H.pad(icon .. os.date(fmt), opts)
end

return M
