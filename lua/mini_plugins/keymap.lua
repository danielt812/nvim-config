local keymap = require("mini.keymap")

-- stylua: ignore start
local map_multistep = keymap.map_multistep
local map_combo     = keymap.map_combo
-- stylua: ignore end

local tab_steps = {
  "minisnippets_next",
  "increase_indent",
  "minisnippets_expand",
  "jump_after_tsnode",
  "jump_after_close",
}
map_multistep("i", "<Tab>", tab_steps)

local shifttab_steps = {
  "minisnippets_prev",
  "decrease_indent",
  "jump_before_tsnode",
  "jump_before_open",
}

map_multistep("i", "<S-Tab>", shifttab_steps)

-- stylua: ignore start
map_multistep({ "i", "c" }, "<C-j>",  { "pmenu_next" })
map_multistep({ "i", "c" }, "<C-k>",  { "pmenu_prev" })
map_multistep({ "i", "c" }, "<C-CR>", { "pmenu_accept" })
-- stylua: ignore end

-- Handle pair plugins
map_multistep("i", "<CR>", { "nvimautopairs_cr", "minipairs_cr" })
map_multistep("i", "<BS>", { "nvimautopairs_bs", "minipairs_bs" })

map_combo("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })
