local map = require("mini.map")

map.setup({
  symbols = {
    encode = map.gen_encode_symbols.dot("4x2"),
    scroll_line = "▶ ",
    scroll_view = "┃ ",
  },
  integrations = {
    map.gen_integration.builtin_search(),
    map.gen_integration.diff(),
    map.gen_integration.diagnostic(),
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

vim.keymap.set("n", "<leader>em", map.toggle, { desc = "Map" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local au_group = vim.api.nvim_create_augroup("mini_map", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = au_group,
  desc = "Auto open mini map",
  callback = map.open,
})
