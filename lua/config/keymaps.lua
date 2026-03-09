local function get_page_size(size)
  local height = vim.api.nvim_win_get_height(0)
  if size == "half" then return math.floor(height / 2) end
  return height - 2
end

local function move_lines(count, direction)
  if count <= 0 then return end
  vim.cmd("normal! " .. count .. (direction == "down" and "j" or "k"))
end

local function page_down() move_lines(get_page_size("full"), "down") end
local function page_up() move_lines(get_page_size("full"), "up") end
local function half_page_down() move_lines(get_page_size("half"), "down") end
local function half_page_up() move_lines(get_page_size("half"), "up") end

-- -- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<PageDown>", page_down,      { desc = "Move page down" })
vim.keymap.set({ "n", "v" }, "<C-f>",      page_down,      { desc = "Move page down" })
vim.keymap.set({ "n", "v" }, "<C-d>",      half_page_down, { desc = "Move half page down" })
vim.keymap.set({ "n", "v" }, "<PageUp>",   page_up,        { desc = "Move page up" })
vim.keymap.set({ "n", "v" }, "<C-b>",      page_up,        { desc = "Move page up" })
vim.keymap.set({ "n", "v" }, "<C-u>",      half_page_up,   { desc = "Move half page up" })
-- -- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Go to next buffer" })
-- stylua: ignore end

-- Preserve cursor position on yank
local function preserve_cursor(key)
  local pos = vim.fn.getpos("v")
  vim.w._yank_cursor_pos = { pos[2], pos[3] - 1 }
  return key
end

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "y", function() return preserve_cursor("y") end, { expr = true, desc = "Yank" })
vim.keymap.set({ "n", "v" }, "Y", function() return preserve_cursor("Y") end, { expr = true, desc = "Yank line" })
-- stylua: ignore end

-- Prevent some registers from yanking
-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Prevent x from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "X", '"_X', { desc = "Prevent X from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Prevent c from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Prevent C from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "s", '"_s', { desc = "Prevent s from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "S", '"_S', { desc = "Prevent S from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "r", '"_r', { desc = "Prevent r from yanking to clipboard" })
vim.keymap.set({ "n", "v" }, "R", '"_R', { desc = "Prevent R from yanking to clipboard" })
-- stylua: ignore start

-- Indent QOL
-- stylua: ignore start
vim.keymap.set("v", "<", "<gv", { desc = "Indent block to left",  silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent block to right", silent = true })
vim.keymap.set("n", "<", "<<",  { desc = "Indent line to left",   silent = true })
vim.keymap.set("n", ">", ">>",  { desc = "Indent line to right",  silent = true })
-- stylua: ignore end

vim.keymap.set("n", "U", "<c-r>", { desc = "Redo", silent = true })

vim.keymap.set("n", "dd", function()
  if vim.fn.getline("."):match("^%s*$") then return '"_dd' end
  return "dd"
end, { expr = true })

vim.keymap.set("n", "yy", function()
  if vim.fn.getline(".") ~= "" then vim.cmd("normal! yy") end
end, { noremap = true, silent = true })

-- Put this into keymaps.lua
vim.keymap.set("n", "<C-r>", function()
  package.loaded["modules.blame"] = nil
  require("modules.blame").setup()
  vim.notify("modules.blame reloaded")
end, { desc = "Reload Blame Module" })

-- Create scratch buffer
-- vim.keymap.set("n", "<leader>bs", function()
--   vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
-- end, { desc = "Scratch" })
