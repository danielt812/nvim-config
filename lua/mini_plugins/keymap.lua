local keymap = require("mini.keymap")

-- stylua: ignore start
local map_multistep = keymap.map_multistep
local map_combo     = keymap.map_combo
-- stylua: ignore end

local inline_completion = {
  condition = function() return vim.lsp.inline_completion.is_enabled({ bufnr = 0 }) end,
  action = function() vim.lsp.inline_completion.get() end,
}

local tab_steps = {
  inline_completion,
  "minisnippets_next",
  "increase_indent",
  "jump_after_tsnode",
  "jump_after_close",
  "minisnippets_expand",
}
map_multistep("i", "<tab>", tab_steps)

local shifttab_steps = {
  "minisnippets_prev",
  "decrease_indent",
  "jump_before_tsnode",
  "jump_before_open",
}

map_multistep("i", "<s-tab>", shifttab_steps)

-- stylua: ignore start
map_multistep({ "i", "c" }, "<c-j>",  { "pmenu_next" })
map_multistep({ "i", "c" }, "<c-k>",  { "pmenu_prev" })
map_multistep({ "i", "c" }, "<c-cr>", { "pmenu_accept" })
-- stylua: ignore end

-- Handle pair plugins
map_multistep("i", "<cr>", { "nvimautopairs_cr", "minipairs_cr" })
map_multistep("i", "<bs>", { "nvimautopairs_bs", "minipairs_bs" })

map_combo("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })
