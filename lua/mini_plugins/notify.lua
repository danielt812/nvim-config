local notify = require("mini.notify")

local function in_lsp_progress() return vim.lsp.status() ~= "" end

local function format(notif)
  if notif.data.source ~= "lsp_progress" then return notify.default_format(notif) end
  local response = notif.data.response
  local value = response and response.value or {}
  local title = value.title or ""
  local message = value.message or ""
  local pct = value.percentage
  if value.kind == "end" then return title .. ": done" end
  local parts = { title }
  if message ~= "" then parts[#parts + 1] = message end
  if pct then parts[#parts + 1] = "(" .. pct .. "%)" end
  return table.concat(parts, " ")
end

local function window_config()
  local has_winbar = vim.o.winbar ~= "" and 1 or 0
  local has_tabline = vim.o.tabline ~= "" and 1 or 0
  local has_status = vim.o.laststatus > 0 and 1 or 0

  local notify_pad = 0 + has_winbar + has_tabline

  -- Notifications in top right
  if not in_lsp_progress() then return {
    anchor = "NE",
    row = notify_pad,
  } end

  -- Lsp progress in bottom right
  local lsp_pad = vim.o.cmdheight + has_status
  return {
    anchor = "SE",
    col = vim.o.columns - 2,
    row = vim.o.lines - lsp_pad,
    border = "none",
  }
end

notify.setup({
  lsp_progress = {
    duration_last = 500,
  }, -- default duration: 1000
  content = { format = format }, -- sort = H.filterout_lua_diagnosing
  window = {
    winblend = 95,
    config = window_config,
  },
})

vim.notify = notify.make_notify()

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function history() notify.show_history() end

vim.keymap.set("n", "<leader>en", history, { desc = "Notifications" })
