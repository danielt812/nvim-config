local notify = require("mini.notify")

local n_progress = 0

local function in_lsp_progress() return n_progress > 0 end

local function lsp_progress_plus() n_progress = n_progress + 1 end

local function lsp_progress_minus()
  vim.defer_fn(function() n_progress = n_progress - 1 end, notify.config.lsp_progress.duration_last + 1)
end

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    if value.kind == "begin" then lsp_progress_plus() end
    if value.kind == "end" then lsp_progress_minus() end
  end,
})

local function format(notif) return notif.data.source == "lsp_progress" and notif.msg or notify.default_format(notif) end

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
