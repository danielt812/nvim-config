local misc = require("mini.misc")

misc.setup()
misc.setup_restore_cursor()
misc.setup_termbg_sync()

-- https://github.com/echasnovski/mini.nvim/issues/1911
-- NOTE: - Zoom without changing background color
local zoom = function()
  misc.zoom()
  -- stylua: ignore
  if vim.api.nvim_win_get_config(0).relative == "" then return end

  vim.wo.winbar = nil
  vim.wo.winhighlight = "NormalFloat:Normal"
end

local centered_zoom = function()
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.ceil(ui.width / 2)
  local height = ui.height

  misc.zoom(0, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((ui.width - width) / 2),
    row = 2,
    style = "minimal",
  })

  vim.wo.winhighlight = "NormalFloat:Normal"
end

vim.keymap.set("n", "<leader>ez", centered_zoom, { desc = "Zoom" })
