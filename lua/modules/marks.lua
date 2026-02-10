-- #############################################################################
-- #                               Marks Module                                #
-- #############################################################################

-- Module definition -----------------------------------------------------------
local ModMarks = {}
local H = {}

--- Module setup
---
---@param config table|nil Module config table. See |ModMarks.config|.
---
---@usage >lua
---   require('mod.marks').setup() -- use default config
---   -- OR
---   require('mod.marks').setup({}) -- replace {} with your config table
--- <
ModMarks.setup = function(config)
  -- Export module
  _G.ModMarks = ModMarks

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)

  -- Define behavior
  H.create_autocmds()

  -- Create default highlighting
  H.create_default_hl()
end

ModMarks.config = {
  -- stylua: ignore start
  mappings = {
    delete_mark = "dm",
    set_mark    = "m",
  },

  signs = {
    local_marks  = true,
    global_marks = true,
    priority     = 3,
  },
  -- stylua: ignore end
}

-- Helper data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModMarks.config)

H.ns_id = vim.api.nvim_create_namespace("ModMarks")

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")
  H.check_type("mappings.delete_mark", config.mappings.delete_mark, "string")
  H.check_type("mappings.set_mark", config.mappings.set_mark, "string")

  H.check_type("signs", config.signs, "table")
  H.check_type("signs.local_marks", config.signs.local_marks, "boolean")
  H.check_type("signs.global_marks", config.signs.global_marks, "boolean")
  H.check_type("signs.priority", config.signs.priority, "number")

  return config
end

H.apply_config = function(config)
  ModMarks.config = config

  local maps = config.mappings

  H.map("n", maps.delete_mark, ModMarks.delete_mark, { desc = "Delete mark" })
  H.map("n", maps.set_mark, ModMarks.set_mark, { desc = "Delete mark" })
  vim.keymap.set("n", "<leader>ms", H.apply_extmarks, { desc = "Set ext marks" })
  -- Define behavior
  H.create_autocmds()

  -- Create default highlighting
  H.create_default_hl()
end

H.create_default_hl = function()
  local hi = function(name, opts)
    opts.default = true
    vim.api.nvim_set_hl(0, name, opts)
  end

  hi("ModMarksSign", { link = "Constant" })
end

-- Module functionality --------------------------------------------------------
-- Normal keymaps
ModMarks.delete_mark = function(char)
  char = char or vim.fn.getcharstr()

  local buf_id = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_del_mark(buf_id, char)

  H.apply_extmarks()
end

ModMarks.set_mark = function(char)
  char = char or vim.fn.getcharstr()

  local win_id = vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win_id))

  vim.api.nvim_buf_set_mark(0, char, row, col, {})

  H.apply_extmarks()
end

-- Quickfix
ModMarks.send_marks_to_qf = function(opts)
  opts = opts or {}
  local items = H.marks_to_list_items(opts)
  vim.fn.setqflist({}, "r", {
    title = opts.title or "Marks",
    items = items,
  })
  if opts.open ~= false and #items > 0 then vim.cmd("copen") end
end

-- Location list
ModMarks.send_marks_to_loc = function(opts)
  opts = opts or {}
  local winid = opts.winid or 0
  local items = H.marks_to_list_items(opts)
  vim.fn.setloclist(winid, {}, "r", {
    title = opts.title or "Marks (loclist)",
    items = items,
  })

  if opts.open ~= false and #items > 0 then vim.cmd("lopen") end
end

H.apply_extmarks = function()
  local buf_id = vim.api.nvim_get_current_buf()
  -- Clear highlights before applying/removing new marks
  H.clear_ns(buf_id, H.ns_id)

  local global_marks = vim.tbl_filter(
    function(m) return m.mark:sub(-1):match("^[A-Z]$") and m.pos[1] == buf_id end,
    vim.fn.getmarklist()
  )

  local local_marks = vim.tbl_filter(function(m) return m.mark:sub(-1):match("^[a-z]$") end, vim.fn.getmarklist(buf_id))

  H.place_extmarks(global_marks, buf_id, "global")
  H.place_extmarks(local_marks, buf_id, "local")
end

H.place_extmarks = function(marks, buf_id, scope)
  for _, m in ipairs(marks) do
    local char = m.mark:sub(-1)
    local pos = m.pos -- { buf_id, lnum, col, off }
    local lnum = pos[2]
    if lnum == 0 then goto continue end

    local extmark_opts = { sign_text = char, sign_hl_group = "ModMarksSign", priority = ModMarks.config.signs.priority }

    if ModMarks.config.signs.global_marks and scope == "global" then
      vim.api.nvim_buf_set_extmark(buf_id, H.ns_id, lnum - 1, 0, extmark_opts)
    end

    if ModMarks.config.signs.local_marks and scope == "local" then
      vim.api.nvim_buf_set_extmark(buf_id, H.ns_id, lnum - 1, 0, extmark_opts)
    end

    ::continue::
  end
end

H.marks_to_list_items = function(opts)
  opts = opts or {}
  local scope = opts.scope or "local"
  local buf_id = opts.buf_id or vim.api.nvim_get_current_buf()

  local marks = {}
  if scope == "global" then
    vim.list_extend(marks, vim.fn.getmarklist())
  elseif scope == "local" then
    vim.list_extend(marks, vim.fn.getmarklist(buf_id))
  else
    error('marks_to_list_items: opts.scope must be "local" or "global"')
  end

  local items = {}
  for _, m in ipairs(marks) do
    local char = m.mark:sub(-1)
    local is_local = char:match("^[a-z]$")
    local is_global = char:match("^[A-Z]$")

    local pos = m.pos -- { buf_id, lnum, col, off }
    local bufnr, lnum, col = pos[1], pos[2], pos[3]

    if lnum ~= 0 then
      if (scope == "local" and is_local) or (scope == "global" and is_global) then
        table.insert(items, {
          bufnr = bufnr,
          lnum = lnum,
          col = (col or 0) + 1,
          text = string.format("mark %s", char),
        })
      end
    end
  end

  table.sort(items, function(a, b)
    if a.bufnr ~= b.bufnr then return a.bufnr < b.bufnr end
    if a.lnum ~= b.lnum then return a.lnum < b.lnum end
    return a.col < b.col
  end)

  return items
end


H.debounce = function(ms, fn)
  local timer = vim.loop.new_timer()
  if not timer then return end

  return function(...)
    local argv = { ... }
    timer:stop()
    timer:start(ms, 0, function()
      vim.schedule(function() fn(unpack(argv)) end)
    end)
  end
end

H.refresh_extmarks_debounced = H.debounce(100, function() H.apply_extmarks() end)

H.on_mark_command = function()
  vim.schedule(function()
    local last_cmd = vim.fn.histget("cmd", -1)
    if last_cmd:match("^m[a-zA-Z0-9]") or last_cmd:match("^delm") then H.apply_extmarks() end
  end)
end

-- Autocommands ----------------------------------------------------------------
H.create_autocmds = function()
  local group = vim.api.nvim_create_augroup("ModMarks", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end

  au({ "TextChanged", "TextChangedI" }, "*", H.refresh_extmarks_debounced, "Refresh mark signs after edits")
  au({ "BufEnter", "WinEnter" }, "*", H.apply_extmarks, "Set extension marks")
  au("CmdlineLeave", "*", H.on_mark_command, "Refresh extention marks")
  au("ColorScheme", "*", H.create_default_hl, "Ensure colors")
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(module.marks) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

H.clear_ns = function(buf_id, ns_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()
  ns_id = ns_id or H.ns_id
  vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
end

return ModMarks
