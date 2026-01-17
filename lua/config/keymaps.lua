-- Better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set({ "n" }, "<S-h>", "<cmd>bprevious<cr>")
vim.keymap.set({ "n" }, "<S-l>", "<cmd>bnext<cr>")

-- Move to window/tmux pane using ctrl + hjkl keys
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window", remap = true })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window", remap = true })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window", remap = true })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window", remap = true })

-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor line on scroll up" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor line on scroll down" })
-- vim.keymap.set("n", "<C-b>", "<C-b>zz", { desc = "Center cursor line on page up" })
-- vim.keymap.set("n", "<C-f>", "<C-f>zz", { desc = "Center cursor line on page down" })
-- vim.keymap.set("n", "<PageUp>", "<PageUp>zz", { desc = "Center cursor line on page up" })
-- vim.keymap.set("n", "<PageDown>", "<PageDown>zz", { desc = "Center cursor line on page down" })

-- Prevent some registers from yanking
vim.keymap.set({ "n", "v", "x" }, "x", '"_x', { desc = "Prevent x from yanking to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "X", '"_X', { desc = "Prevent X from yanking to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "c", '"_c', { desc = "Prevent c from yanking to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "C", '"_C', { desc = "Prevent C from yanking to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "s", '"_s', { desc = "Prevent s from yanking to clipboard" })
vim.keymap.set({ "n", "v", "x" }, "S", '"_S', { desc = "Prevent S from yanking to clipboard" })

-- stylua: ignore start
vim.keymap.set("x", "<", "<gv", { desc = "Indent block to left",  silent = true })
vim.keymap.set("x", ">", ">gv", { desc = "Indent block to right", silent = true })
vim.keymap.set("n", "<", "<<",  { desc = "Indent line to left",   silent = true })
vim.keymap.set("n", ">", ">>",  { desc = "Indent line to right",  silent = true })
-- stylua: ignore end

vim.keymap.set("n", "U", "<c-r>", { desc = "Redo", silent = true })

-- Keep cursor placement after yanking
vim.keymap.set({ "n", "x" }, "y", function()
  vim.b.cursor_pre_yank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true })

vim.keymap.set("n", "Y", function()
  vim.b.cursor_pre_yank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true })
