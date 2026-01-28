local scroll = require("utils.window-scroll")

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<PageDown>", scroll.page_down,      { desc = "Scroll page down" })
vim.keymap.set({ "n", "v" }, "<C-f>",      scroll.page_down,      { desc = "Scroll page down" })
vim.keymap.set({ "n", "v" }, "<C-d>",      scroll.half_page_down, { desc = "Scroll half page down" })
vim.keymap.set({ "n", "v" }, "<PageUp>",   scroll.page_up,        { desc = "Scroll page up" })
vim.keymap.set({ "n", "v" }, "<C-b>",      scroll.page_up,        { desc = "Scroll page up" })
vim.keymap.set({ "n", "v" }, "<C-u>",      scroll.half_page_up,   { desc = "Scroll half page up" })
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Go to next buffer" })
-- stylua: ignore end

-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor line on scroll up" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor line on scroll down" })
-- vim.keymap.set("n", "<C-b>", "<C-b>zz", { desc = "Center cursor line on page up" })
-- vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "Center cursor line on page down" })
-- vim.keymap.set("n", "<PageUp>", "<PageUp>zz", { desc = "Center cursor line on page up" })
-- vim.keymap.set("n", "<PageDown>", "<PageDown>zz", { desc = "Center cursor line on page down" })

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
vim.keymap.set("x", "<", "<gv", { desc = "Indent block to left",  silent = true })
vim.keymap.set("x", ">", ">gv", { desc = "Indent block to right", silent = true })
vim.keymap.set("n", "<", "<<",  { desc = "Indent line to left",   silent = true })
vim.keymap.set("n", ">", ">>",  { desc = "Indent line to right",  silent = true })
-- stylua: ignore end

vim.keymap.set("n", "U", "<c-r>", { desc = "Redo", silent = true })

-- Create scratch buffer
-- vim.keymap.set("n", "<leader>bs", function()
--   vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
-- end, { desc = "Scratch" })

vim.keymap.set("n", "<C-r>", function()
  package.loaded["modules.yank"] = nil
  require("modules.yank").setup()
  vim.notify("modules.yank reloaded")
end, { desc = "Reload Yank Module" })
