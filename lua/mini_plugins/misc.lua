local misc = require("mini.misc")

misc.setup({
  make_global = { "put", "put_text" },
})

misc.setup_restore_cursor()
misc.setup_termbg_sync()

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local zoom = function()
  misc.zoom()
  -- stylua: ignore
  if vim.api.nvim_win_get_config(0).relative == "" then return end

  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.wo.winhighlight = "NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal"
end

local centered_zoom = function()
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.ceil(ui.width / 2)
  local height = ui.height

  misc.zoom(0, {
    width = width,
    height = height,
    col = math.floor((ui.width - width) / 2),
    row = 2,
    style = "minimal",
    title = " Zoom (centered) ",
  })

  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.wo.winhighlight = "NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal"
end

local put_messages = function()
  put_text(vim.split(vim.api.nvim_exec2("messages", { output = true }).output, "\n"))
end

vim.keymap.set("n", "<leader>ep", put_messages , { desc = "Put messages" })
vim.keymap.set("n", "<leader>ez", zoom, { desc = "Zoom" })
vim.keymap.set("n", "<leader>eZ", centered_zoom, { desc = "Zoom (centered)" })
