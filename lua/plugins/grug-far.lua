local grugfar = require("grug-far")

grugfar.setup()

local utils = require("utils")

utils.map("n", "<leader>eg", "<cmd>GrugFar<cr>", { desc = "GrugFar" })
