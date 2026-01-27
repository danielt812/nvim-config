local treesj = require("treesj")

treesj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 10000,
  cursor_behavior = "hold",
  notify = true,
  dot_repeat = true,
})

vim.keymap.set({ "n", "x" }, "J", treesj.toggle, { desc = "Split/Join" })
