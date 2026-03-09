local grugfar = require("grug-far")

grugfar.setup()

-- stylua: ignore
local function open() grugfar.open() end

vim.keymap.set("n", "<leader>eg", open, { desc = "GrugFar" })
