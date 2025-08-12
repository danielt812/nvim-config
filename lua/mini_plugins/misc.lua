local misc = require("mini.misc")
local utils = require("utils")

misc.setup()

-- https://github.com/echasnovski/mini.nvim/issues/1911
-- NOTE - Zoom without changing background color
_G.zoom = function()
  misc.zoom()
  if vim.api.nvim_win_get_config(0).relative == "" then
    return
  end

  vim.wo.winhighlight = "NormalFloat:Normal"
end

misc.setup_restore_cursor()

-- utils.map("n", "<leader>ez", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "Zoom" })
utils.map("n", "<leader>ez", "<cmd>lua zoom()<cr>", { desc = "Zoom" })
