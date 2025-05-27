local basics = require("mini.basics")

basics.setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = "bold",
  },
  mappings = {
    basic = true,
    option_toggle_prefix = nil,
    windows = true,
    move_with_alt = true,
  },
  autocommands = {
    basic = false,
    relnum_in_visual_mode = false,
  },
})
