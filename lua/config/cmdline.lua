if vim.fn.has("nvim-0.12") ~= 1 then return end

local ok, ui2 = pcall(require, "vim._core.ui2")
if not ok then return end

ui2.enable({})

vim.o.cmdheight = 0

local config = {
  width = { value = "60%", min = 40, max = 80 },
  position = { x = "50%", y = "50%" },
  border = (vim.o.winborder ~= "" and vim.o.winborder) or "rounded",
  menu_col_offset = 3,
  native_types = {},
}

local cmdline_type = nil
local original_ui_cmdline_pos = vim.g.ui_cmdline_pos
local cmd_win_saved = nil
local wrapped = false

local function get_cmd_win()
  local win = ui2.wins and ui2.wins.cmd
  if win and vim.api.nvim_win_is_valid(win) then return win end
end

local function set_cmdheight_0()
  vim._with({ noautocmd = true, o = { splitkeep = "screen" } }, function() vim.o.cmdheight = 0 end)
end

local function parse_dimension(value, available)
  if type(value) == "string" then
    local pct = tonumber(value:match("^(%d+)%%$"))
    return pct and math.floor(available * pct / 100) or 0
  end
  return math.floor(value)
end

local function geometry(content_height)
  local cols, lines = vim.o.columns, vim.o.lines
  local b = config.border == "none" and 0 or 1
  local width = math.max(config.width.min, math.min(config.width.max, parse_dimension(config.width.value, cols)))
  width = math.min(width, cols - 4)
  local row = math.max(0, parse_dimension(config.position.y, lines - content_height - b * 2))
  local col = math.max(0, parse_dimension(config.position.x, cols - width - b * 2))
  return width, row, col, b
end

local function reposition()
  local win = get_cmd_win()
  if not win then return end
  local buf = vim.api.nvim_win_get_buf(win)
  local content_height = math.max(1, vim.api.nvim_buf_line_count(buf))

  if not cmd_win_saved then
    cmd_win_saved = vim.api.nvim_win_get_config(win)
    vim.wo[win].winhighlight = "Normal:MsgArea,FloatBorder:FloatBorder"
  end

  if cmdline_type and vim.tbl_contains(config.native_types, cmdline_type) then
    pcall(vim.api.nvim_win_set_config, win, {
      relative = "editor",
      row = vim.o.lines - content_height,
      col = 0,
      width = vim.o.columns,
      height = content_height,
      border = "none",
      hide = false,
    })
    vim.g.ui_cmdline_pos = original_ui_cmdline_pos
    return
  end

  local width, row, col, b = geometry(content_height)
  pcall(vim.api.nvim_win_set_config, win, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = content_height,
    border = config.border,
    hide = false,
  })
  vim.g.ui_cmdline_pos = { row + content_height + b * 2, col + b + config.menu_col_offset }
end

local function wrap_cmdline_show()
  if wrapped then return end
  local cmdline_ok, cmdline_mod = pcall(require, "vim._core.ui2.cmdline")
  if not cmdline_ok then return end
  local orig = cmdline_mod.cmdline_show
  cmdline_mod.cmdline_show = function(...)
    local ret = orig(...)
    if cmdline_type then
      local is_search = cmdline_type == "/" or cmdline_type == "?"
      if not is_search and not vim.tbl_contains(config.native_types, cmdline_type) then set_cmdheight_0() end
      reposition()
    end
    return ret
  end
  wrapped = true
end

local group = vim.api.nvim_create_augroup("cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  callback = function() cmdline_type = vim.fn.getcmdtype() end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  callback = function()
    cmdline_type = nil
    vim.g.ui_cmdline_pos = original_ui_cmdline_pos
    local win = get_cmd_win()
    if win and cmd_win_saved then
      local restore = vim.tbl_extend("force", cmd_win_saved, { hide = true })
      pcall(vim.api.nvim_win_set_config, win, restore)
    end
    vim.schedule(set_cmdheight_0)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "cmd",
  callback = function() vim.schedule(wrap_cmdline_show) end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    vim.schedule(function()
      local win = get_cmd_win()
      if win then pcall(vim.api.nvim_win_set_config, win, { hide = true }) end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "VimResized", "TabEnter" }, {
  group = group,
  callback = function()
    if cmdline_type then reposition() end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  desc = "Clear lingering ui2 messages when entering insert mode",
  callback = function() pcall(vim.cmd, "echo ''") end,
})
