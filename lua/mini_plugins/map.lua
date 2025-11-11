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

-- stylua: ignore
local toggle = function() map.toggle() end

vim.keymap.set("n", "<leader>em", toggle, { desc = "Map" })
