local notify = require("mini.notify")

local n_progress = 0

local in_lsp_progress = function()
  return n_progress > 0
end

local lsp_progress_plus = function()
  n_progress = n_progress + 1
end

local lsp_progress_minus = function()
  vim.defer_fn(function()
    n_progress = n_progress - 1
  end, notify.config.lsp_progress.duration_last + 1)
end

vim.api.nvim_create_autocmd("LspProgress", { pattern = "begin", callback = lsp_progress_plus })
vim.api.nvim_create_autocmd("LspProgress", { pattern = "end", callback = lsp_progress_minus })

local format = function(notif)
  return notif.data.source == "lsp_progress" and notif.msg or notify.default_format(notif)
end
vim.api.nvim_set_hl(0, "notifyLspProgress", { link = "Comment" })

local window_config = function()
  local has_winbar = vim.o.winbar ~= "" and 1 or 0
  local has_tabline = vim.o.tabline ~= "" and 1 or 0
  local has_status = vim.o.laststatus > 0 and 1 or 0

  local notify_pad = 0 + has_winbar + has_tabline

  -- Notifications in top right
  if not in_lsp_progress() then
    return {
      anchor = "NE",
      row = notify_pad,
    }
  end

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
  lsp_progress = { duration_last = 500 }, -- default duration: 1000
  content = { format = format }, -- sort = H.filterout_lua_diagnosing
  window = {
    winblend = 95,
    config = window_config,
  },
})

vim.notify = notify.make_notify()

-- stylua: ignore start
local clear = function() notify.clear() end
local history = function() notify.show_history() end
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<leader>nc", clear,   { desc = "Clear" })
vim.keymap.set("n", "<leader>nh", history, { desc = "History" })
-- stylua: ignore end
