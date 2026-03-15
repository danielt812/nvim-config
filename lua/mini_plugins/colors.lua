local colors = require("mini.colors")
colors.setup()

local ns = vim.api.nvim_create_namespace("on_highlight")
local group = vim.api.nvim_create_augroup("mini_colors", { clear = true })

local function hl_bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl.bg and string.format("#%06X", hl.bg) or "#000000"
end

--- Interpolate between two hex colors in oklab space
--- @param factor number 0 = from_hex, 1 = to_hex
local function lerp_color(factor, from_hex, to_hex)
  local from = colors.convert(from_hex, "oklab")
  local to = colors.convert(to_hex, "oklab")
  if not (from and to and from.l and to.l) then return to_hex end
  return colors.convert({
    l = from.l + (to.l - from.l) * factor,
    a = from.a + (to.a - from.a) * factor,
    b = from.b + (to.b - from.b) * factor,
  }, "hex") --[[@as string]]
end

local function out_quad(t) return t * (2 - t) end
local function out_back(t)
  t = t - 1
  return t * t * (2.70158 * t + 1.70158) + 1
end

local function effect_fade() return out_quad end
local function effect_reverse_fade() return out_back end
local function effect_pulse(count)
  count = count or 1
  return function(p) return math.sin(p * math.pi * count) end
end
local function effect_bounce(count)
  count = count or 2
  return function(p) return math.abs(math.sin(p * math.pi * count)) end
end

local function effect_ltr(sweep_end)
  sweep_end = sweep_end or 0.85
  return function(p)
    local ltr = math.min(p / sweep_end, 1.0)
    local factor = p < sweep_end and 0 or out_quad((p - sweep_end) / (1 - sweep_end))
    return factor, ltr
  end
end

local function animate(buf, from_hl, to_hl, ranges, max_dur, min_dur, effect)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.bo[buf].filetype == "ministarter" then return end
  if #ranges == 0 then return end

  effect = effect or effect_fade()
  local from = hl_bg(from_hl)
  local to = hl_bg(to_hl)
  local hl = "On_" .. vim.uv.now()

  local length = 0
  for _, range in ipairs(ranges) do
    length = length + (range.end_col - range.start_col)
  end
  local dur = length <= 0 and min_dur or length >= 10 and max_dur or math.max(length * max_dur / 10, min_dur)

  local start_time = vim.uv.now()
  local timer = vim.uv.new_timer()
  if not timer then return end
  local closed = false

  local function stop()
    if closed then return end
    closed = true
    timer:stop()
    timer:close()
  end

  timer:start(
    0,
    8,
    vim.schedule_wrap(function()
      if closed then return end

      if not vim.api.nvim_buf_is_valid(buf) then
        stop()
        return
      end

      local progress = math.min((vim.uv.now() - start_time) / dur, 1)
      local factor, ltr = effect(progress)
      vim.api.nvim_set_hl(0, hl, { bg = lerp_color(factor, from, to) })

      for _, range in ipairs(ranges) do
        vim.api.nvim_buf_clear_namespace(buf, ns, range.start_row, range.end_row + 1)
      end

      if progress >= 1 then
        stop()
        return
      end

      for _, range in ipairs(ranges) do
        local multi = range.start_row ~= range.end_row
        for line = range.start_row, range.end_row do
          local start_col, end_col
          if line == range.start_row then
            start_col = range.start_col
            local full = (range.end_col - range.start_col == 0 or multi) and 99999 or (range.end_col - range.start_col)
            end_col = ltr and math.floor(full * ltr) or full
          elseif line < range.end_row then
            start_col, end_col = 0, 99999
          else
            start_col = 0
            end_col = ltr and math.floor(range.end_col * ltr) or range.end_col
          end
          pcall(vim.api.nvim_buf_set_extmark, buf, ns, line, math.max(0, start_col), {
            end_col = start_col + end_col,
            hl_group = hl,
            hl_mode = "blend",
            priority = 2048,
            strict = false,
          })
        end
      end
    end)
  )
end

local function wrap_keymap(mode, lhs, cmd)
  local function add_count_reg(keys)
    local result = vim.api.nvim_replace_termcodes(keys, true, false, true)
    if vim.v.register ~= nil then result = '"' .. vim.v.register .. result end
    if vim.v.count > 1 then result = vim.v.count .. result end
    return result
  end

  local orig = vim.fn.maparg(lhs, mode, false, true) --[[@as table?]]
  if orig and orig.rhs and orig.rhs:find("<SID>") then return end
  if orig and orig.buffer and orig.buffer ~= 0 then orig = nil end

  vim.keymap.set(mode, lhs, function()
    if vim.fn.reg_executing() ~= "" then
      if orig and orig.callback then
        orig.callback()
      elseif orig and orig.rhs then
        vim.api.nvim_feedkeys(add_count_reg(orig.rhs), "n", true)
      else
        vim.api.nvim_exec2("normal! " .. lhs, {})
      end
      return
    end

    if cmd then cmd() end

    if orig and orig.callback then
      for _ = 1, vim.v.count1 do
        orig.callback()
      end
    elseif orig and orig.rhs then
      vim.api.nvim_feedkeys(add_count_reg(orig.rhs), "n", true)
    else
      vim.api.nvim_feedkeys(add_count_reg(lhs), "n", true)
    end
  end, { noremap = true })
end

-- Yank ---------------------------------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    if vim.v.event.operator == "d" or vim.v.event.operator == "c" then return end
    local yank_range = {
      start_row = vim.fn.line("'[") - 1,
      start_col = vim.fn.col("'[") - 1,
      end_row = vim.fn.line("']") - 1,
      end_col = vim.fn.col("']"),
    }
    vim.schedule(function() animate(vim.api.nvim_get_current_buf(), "OnYank", "Normal", { yank_range }, 800, 500) end)
  end,
})

-- Paste --------------------------------------------------------------------------

local paste_attached = {}

local function on_paste()
  if vim.fn.reg_executing() ~= "" then return end
  local buf = vim.api.nvim_get_current_buf()
  if paste_attached[buf] then return end

  local function merge_ranges(ranges)
    if #ranges == 0 then return {} end
    table.sort(
      ranges,
      function(left, right)
        return left.start_row < right.start_row
          or (left.start_row == right.start_row and left.start_col < right.start_col)
      end
    )
    local merged = { ranges[1] }
    for idx = 2, #ranges do
      local prev, cur = merged[#merged], ranges[idx]
      if cur.start_row <= prev.end_row and cur.start_col <= prev.end_col then
        prev.end_row = math.max(prev.end_row, cur.end_row)
        prev.end_col = math.max(prev.end_col, cur.end_col)
      else
        table.insert(merged, cur)
      end
    end
    return merged
  end

  local ranges = {}
  local done = false
  local debounce_timer = nil

  local function finish()
    done = true
    paste_attached[buf] = nil
    if #ranges > 0 then animate(buf, "OnPaste", "Normal", merge_ranges(ranges), 800, 500) end
  end

  paste_attached[buf] = true
  vim.api.nvim_buf_attach(buf, false, {
    on_bytes = function(_, _, _, start_row, start_col, _, _, _, _, new_rows, new_cols, _)
      if done then return true end
      if vim.fn.reg_executing() ~= "" then
        done = true
        paste_attached[buf] = nil
        if debounce_timer then vim.fn.timer_stop(debounce_timer) end
        return true
      end
      local end_row = start_row + new_rows
      local end_col = start_col + new_cols
      if end_row >= vim.api.nvim_buf_line_count(buf) then
        local last = vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1]
        if last then end_col = #last end
      end
      table.insert(ranges, { start_row = start_row, start_col = start_col, end_row = end_row, end_col = end_col })
      if debounce_timer then vim.fn.timer_stop(debounce_timer) end
      debounce_timer = vim.fn.timer_start(50, finish)
    end,
  })
end

-- Undo / Redo --------------------------------------------------------------------

local function on_undo_redo(from_hl, to_hl, max_dur, min_dur, effect)
  local function offset_to_range(start_row, start_col, delta_rows, delta_cols)
    return {
      start_row = start_row,
      start_col = start_col,
      end_row = start_row + delta_rows,
      end_col = (delta_rows == 0 and start_col or 0) + delta_cols,
    }
  end

  local function is_empty_range(range)
    return range.start_row > range.end_row or (range.start_row == range.end_row and range.start_col >= range.end_col)
  end
  local function is_before(left, right)
    return left.start_row < right.start_row or (left.start_row == right.start_row and left.start_col <= right.start_col)
  end
  local function is_after(left, right)
    return left.end_row > right.end_row or (left.end_row == right.end_row and left.end_col > right.end_col)
  end
  local function is_disjunct(left, right)
    return left.end_row < right.start_row or (left.end_row == right.start_row and left.end_col < right.start_col)
  end

  local function insert_range(guard, old, new)
    if is_empty_range(old) and is_empty_range(new) then return end
    local idx = 1
    while is_before(guard[idx], old) do
      idx = idx + 1
    end

    if is_disjunct(guard[idx - 1], old) then
      table.insert(guard, idx, vim.deepcopy(old))
    else
      if is_after(old, guard[idx - 1]) then
        guard[idx - 1].end_row = old.end_row
        guard[idx - 1].end_col = old.end_col
      end
      idx = idx - 1
    end

    while not is_disjunct(guard[idx], guard[idx + 1]) do
      if is_after(guard[idx + 1], guard[idx]) then
        guard[idx].end_row = guard[idx + 1].end_row
        guard[idx].end_col = guard[idx + 1].end_col
      end
      table.remove(guard, idx + 1)
    end

    local delta_lines = new.end_row - old.end_row
    local delta_cols = new.end_col - old.end_col
    if delta_lines == 0 and delta_cols == 0 then return end

    if guard[idx].end_row == old.end_row then guard[idx].end_col = guard[idx].end_col + delta_cols end
    guard[idx].end_row = guard[idx].end_row + delta_lines
    if is_empty_range(guard[idx]) then
      table.remove(guard, idx)
    else
      idx = idx + 1
    end

    for jdx = idx, #guard - 1 do
      if guard[jdx].start_row == old.end_row then guard[jdx].start_col = guard[jdx].start_col + delta_cols end
      if guard[jdx].end_row == old.end_row then guard[jdx].end_col = guard[jdx].end_col + delta_cols end
      guard[jdx].start_row = guard[jdx].start_row + delta_lines
      guard[jdx].end_row = guard[jdx].end_row + delta_lines
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  local guard = {
    { start_row = -1, start_col = -1, end_row = -1, end_col = -1 },
    { start_row = math.huge, start_col = math.huge, end_row = math.huge, end_col = math.huge },
  }
  local detach = false

  vim.api.nvim_buf_attach(buf, false, {
    on_bytes = function(_, _, _, start_row, start_col, _, old_rows, old_cols, _, new_rows, new_cols, _)
      if detach then return true end
      insert_range(
        guard,
        offset_to_range(start_row, start_col, old_rows, old_cols),
        offset_to_range(start_row, start_col, new_rows, new_cols)
      )
    end,
  })

  return function()
    vim.schedule(function()
      detach = true
      if #guard > 2 then
        table.remove(guard, 1)
        table.remove(guard, #guard)
        animate(buf, from_hl, to_hl, guard, max_dur, min_dur, effect)
      end
    end)
  end
end

-- Keymap Wrappers ----------------------------------------------------------------
-- stylua: ignore start
local function on_undo() vim.schedule(on_undo_redo("OnUndo", "Normal", 800, 500)) end
local function on_redo() vim.schedule(on_undo_redo("OnRedo", "Normal", 800, 500)) end

-- stylua: ignore end

wrap_keymap("n", "p", on_paste)
wrap_keymap("n", "P", on_paste)
wrap_keymap("n", "u", on_undo)
wrap_keymap("n", "U", on_redo)

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function gen_hl_groups()
  local map = {
    OnYank = "BgYellow",
    OnPaste = "BgGreen",
    OnUndo = "BgRed",
    OnRedo = "BgBlue",
  }

  for target_hl, source_hl in pairs(map) do
    local hl = vim.api.nvim_get_hl(0, { name = source_hl, link = false })
    if hl.bg then
      local hex = string.format("#%06X", hl.bg)
      local oklch = colors.convert(hex, "oklch")
      if type(oklch) == "table" and oklch.l and oklch.c then
        oklch.l = math.min(oklch.l + 8, 100)
        oklch.c = math.min(oklch.c + 3, 32)
        vim.api.nvim_set_hl(0, target_hl, {
          bg = colors.convert(oklch, "hex") --[[@as string]],
        })
      end
    end
  end
end

gen_hl_groups() -- Call this now if colorscheme was already set

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})
