local surround = require("mini.surround")

surround.setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",

    suffix_last = "",
    suffix_next = "",
  },
  -- Number of lines within which surrounding is searched
  n_lines = 100,

  -- Whether to respect selection type:
  -- - Place surroundings on separate lines in linewise mode.
  -- - Place surroundings on each line in blockwise mode.
  respect_selection_type = false,
})
