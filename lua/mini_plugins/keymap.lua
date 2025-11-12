local keymap = require("mini.keymap")

-- stylua: ignore start
local map_multistep = keymap.map_multistep
local map_combo     = keymap.map_combo
-- stylua: ignore end

local tab_steps = {
  "minisnippets_next",
  -- "pmenu_next",
  "increase_indent",
  "minisnippets_expand",
  "jump_after_tsnode",
  "jump_after_close",
}
map_multistep("i", "<Tab>", tab_steps)

local shifttab_steps = {
  "minisnippets_prev",
  -- "pmenu_prev",
  "decrease_indent",
  "jump_before_tsnode",
  "jump_before_open",
}

map_multistep("i", "<S-Tab>", shifttab_steps)
-- Use same keybinds as fzf
-- i for regular completion, c for wildmenu
map_multistep({ "i", "c" }, "<C-j>", { "pmenu_next" })
map_multistep({ "i", "c" }, "<C-k>", { "pmenu_prev" })
map_multistep({ "i", "c" }, "<C-CR>", { "pmenu_accept" })

-- Handle pair plugins (trying both, need to learn how neigh patterns work)
map_multistep("i", "<CR>", { "nvimautopairs_cr", "minipairs_cr" })
map_multistep("i", "<BS>", { "nvimautopairs_bs", "minipairs_bs" })

-- stylua: ignore
local no_hlsearch = function() vim.cmd("nohlsearch") end

map_combo({ "n", "i", "x", "c" }, "<Esc><Esc>", no_hlsearch)

map_combo("i", "<", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  -- stylua: ignore
  if line:sub(col - 2, col) == "<<>" then return "<Del>" end
end)

map_combo("i", "=", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  -- stylua: ignore
  if line:sub(col - 2, col) == "<=>" then return "<Del>" end
end)

-- Less intrusive hardtime?
-- local notify_many_keys = function(key)
--   local lhs = string.rep(key, 10)
--   local action = function()
--     vim.notify("Too many " .. key)
--   end
--   map_combo({ "n", "x" }, lhs, action)
-- end

-- notify_many_keys("h")
-- notify_many_keys("j")
-- notify_many_keys("k")
-- notify_many_keys("l")
