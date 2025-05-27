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
