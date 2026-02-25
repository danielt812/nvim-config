local diff = require("mini.diff")

diff.setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
    priority = 1,
  },
  source = nil,
  delay = {
    text_change = 200,
  },
  mappings = {
    apply = "gh",
    reset = "gH",
    textobject = "gh",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },

  -- Various options
  options = {
    algorithm = "histogram",
    indent_heuristic = true,
    linematch = 60,
    wrap_goto = false,
  },
})
