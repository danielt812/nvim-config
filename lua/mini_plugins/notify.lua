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

local au = vim.api.nvim_create_autocmd

au("LspProgress", { pattern = "begin", callback = lsp_progress_plus })
au("LspProgress", { pattern = "end", callback = lsp_progress_minus })

local format = function(notif)
  return notif.data.source == "lsp_progress" and notif.msg or notify.default_format(notif)
end
vim.api.nvim_set_hl(0, "notifyLspProgress", { link = "Comment" })

local window_config = function()
  -- Notifyications in top right
  if not in_lsp_progress() then
    return {}
  end

  -- Lsp progress in bottom right
  local pad = vim.o.cmdheight + (vim.o.laststatus > 0 and 1 or 0)
  return { anchor = "SE", col = vim.o.columns - 2, row = vim.o.lines - pad, border = "none" }
end

notify.setup({
  lsp_progress = { duration_last = 500 }, -- default duration: 1000
  content = { format = format }, -- sort = H.filterout_lua_diagnosing
  window = { winblend = 95, config = window_config },
})

vim.notify = notify.make_notify()

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>nc", "<cmd>lua MiniNotify.clear()<cr>", { desc = "Clear" })
map("n", "<leader>nh", "<cmd>lua MiniNotify.history()<cr>", { desc = "History" })
