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

local utils = require("utils")

utils.map("n", "<leader>em", "<cmd>lua MiniMap.toggle()<cr>", { desc = "Map" })
