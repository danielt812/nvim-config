local misc = require("mini.misc")

misc.setup()

-- https://github.com/echasnovski/mini.nvim/issues/1911
-- NOTE - Zoom without changing background color
local zoom = function()
  misc.zoom()
  -- stylua: ignore
  if vim.api.nvim_win_get_config(0).relative == "" then return end

  vim.wo.winbar = nil
  vim.wo.winhighlight = "NormalFloat:Normal"
end

misc.setup_restore_cursor()

vim.keymap.set("n", "<leader>ez", zoom, { desc = "Zoom" })
