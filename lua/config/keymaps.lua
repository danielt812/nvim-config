-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<PageDown>", "<PageDown>gvzz", { desc = "Scroll down full page" })
vim.keymap.set({ "n", "v" }, "<C-f>",      "<C-f>gvzz",      { desc = "Scroll down full page" })
vim.keymap.set({ "n", "v" }, "<C-d>",      "<C-d>gvzz",      { desc = "Scroll down half page" })
vim.keymap.set({ "n", "v" }, "<PageUp>",   "<PageUp>gvzz",   { desc = "Scroll up full page" })
vim.keymap.set({ "n", "v" }, "<C-b>",      "<C-b>gvzz",      { desc = "Scroll up full page" })
vim.keymap.set({ "n", "v" }, "<C-u>",      "<C-u>gvzz",      { desc = "Scroll up half page" })
-- stylua: ignore end

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

-- Exit from insert mode by Esc in Terminal
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "dd", function()
  if vim.fn.getline("."):match("^%s*$") then return '"_dd' end
  return "dd"
end, { expr = true })

vim.keymap.set("n", "yy", function()
  if vim.fn.getline(".") ~= "" then vim.cmd("normal! yy") end
end, { noremap = true, silent = true })
