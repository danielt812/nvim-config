local line_number_change_mode = require("line-number-change-mode")

line_number_change_mode.setup({
  mode = {
    i = { link = "NumberColumnModeInsert" },
    n = {
      link = "NumberColumnModeNormal",
    },
    R = {
      link = "NumberColumnModeReplace",
    },
    v = {
      link = "NumberColumnModeVisual",
    },
    V = {
      link = "NumberColumnModeVisual",
    },
  },
})
