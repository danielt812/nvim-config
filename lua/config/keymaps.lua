local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Move to window/tmux pane using the <ctl> + hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <alt> + arrow keys
map("n", "<A-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- BufferLine
map("n", "<A-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<A-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })

-- Toggle Join/Split
map("n", "J", "<cmd>TSJToggle<CR>", { desc = "Join/Split" })

-- Toggle Term
map({ "n", "t" }, "<C-/>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal", remap = true })

-- Clear search with <esc>
map({ "n", "i" }, "<esc>", "<cmd>nohlsearch<CR><esc>", { desc = "Escape and clear hlsearch" })

-- n always goes forward and N always go backwards regardless of / or ?
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

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

-- Save file with ctrl-s
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>", { desc = "Save file" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent block to left", silent = true })
map("v", ">", ">gv", { desc = "Indent block to right", silent = true })

-- Yanky
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Yanky put after" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Yanky put before" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Yanky gput after" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Yanky gput after" })
map("n", "]y", "<Plug>(YankyCycleForward)", { desc = "Next yanky" })
map("n", "[y", "<Plug>(YankyCycleBackward)", { desc = "Previous yanky" })

-- Cycle diagnostics
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open Float" })
