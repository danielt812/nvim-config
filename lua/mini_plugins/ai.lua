local ai = require("mini.ai")

ai.setup({
  n_lines = 500,
  custom_textobjects = {
    f = ai.gen_spec.treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }),
    o = ai.gen_spec.treesitter({
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    }),
    A = ai.gen_spec.treesitter({ a = "@attribute.outer", i = "@attribute.inner" }),
    w = { "()()%f[%w_][%w_]+()[ \t]*()" }, -- i: word ([%w_]+), a: word + trailing whitespace
    W = { "()()%f[%S]%S+()[ \t]*()" }, -- i: WORD (%S+), a: WORD + trailing whitespace
    N = { "%f[%d]%d+" }, -- number sequence
  },
})
