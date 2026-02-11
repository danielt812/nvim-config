local operators = require("mini.operators")

operators.setup({
  {
    evaluate = {
      prefix = "g=",
    },
    exchange = {
      prefix = "gx",
    },
    multiply = {
      prefix = "gm",
    },
    replace = {
      prefix = "gr",
    },
    sort = {
      prefix = "gs",
    },
  },
})

vim.keymap.set("n", "(", "gxiagxila", { remap = true, desc = "Swap argument left" })
vim.keymap.set("n", ")", "gxiagxina", { remap = true, desc = "Swap argument right" })
