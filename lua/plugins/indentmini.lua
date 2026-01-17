local indentmini = require("indentmini")

indentmini.setup({
  enabled = true,
  only_current = false,
  exclude = {
    "help",
    "nofile",
    "terminal",
    "prompt",
    "qf",
  },
  exclude_nodetype = {},
  minlevel = 1,
  char = "│",
})
