local map = require("mini.map")

map.setup({
  integrations = {
    map.gen_integration.builtin_search(),
    map.gen_integration.diff(),
    map.gen_integration.diagnostic(),
  },
  symbols = {
    encode = map.gen_encode_symbols.dot("3x2"),
    scroll_line = "▶ ",
    scroll_view = "┃ ",
  },
})

vim.keymap.set("n", "<leader>em", map.toggle, { desc = "Map" })

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("mini_map", { clear = true }),
  desc = "Auto open mini map",
  callback = function(args) end,
})
