local grugfar = require("grug-far")

grugfar.setup()

-- stylua: ignore
local open = function() grugfar.open() end

vim.keymap.set("n", "<leader>eg", open, { desc = "GrugFar" })
