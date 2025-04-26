local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Move to window/tmux pane using ctrl + hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Clear search with <esc>
map({ "n", "i" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Prevent some registers from yanking
map({ "n", "v", "x" }, "x", '"_x', { desc = "Prevent x from yanking to clipboard" })
map({ "n", "v", "x" }, "X", '"_X', { desc = "Prevent X from yanking to clipboard" })
map({ "n", "v", "x" }, "c", '"_c', { desc = "Prevent c from yanking to clipboard" })
map({ "n", "v", "x" }, "C", '"_C', { desc = "Prevent C from yanking to clipboard" })
map({ "n", "v", "x" }, "s", '"_s', { desc = "Prevent s from yanking to clipboard" })
map({ "n", "v", "x" }, "S", '"_S', { desc = "Prevent S from yanking to clipboard" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

map("v", "<", "<gv", { desc = "Indent block to left", silent = true })
map("v", ">", ">gv", { desc = "Indent block to right", silent = true })

map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
