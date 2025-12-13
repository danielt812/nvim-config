local outline = require("outline")

outline.setup({})

vim.keymap.set("n", "<leader>eo", "<cmd>Outline<cr>", { desc = "Outline" })
