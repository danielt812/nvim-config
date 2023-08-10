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

-- Always go to beginning of line when using gg or G
map("n", "gg", "gg0", { desc = "Go to beginning of file" })
map("n", "G", "G0", { desc = "Go to end of file" })

-- Cycle diagnostics
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open Float" })

-- Which-Key Save
map("n", "<leader>s", "<cmd>w<CR>", { desc = "Save  " })

-- Which-Key Quit
map("n", "<leader>q", "<cmd>confirm qa<CR>", { desc = "Quit  " })

-- Which-Key Alpha
map("n", "<leader>;", "<cmd>Alpha<CR>", { desc = "Dashboard 󱒉 " })

-- Which-Key Format
map("n", "<leader>.", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format 󰘞 " })

-- Which-Key Clear Hl
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight 󰹊 " })

-- Which-Key Close-Buffer
map("n", "<leader>c", "<cmd>BufferClose<CR>", { desc = "Close Buffer   " })

-- Which-Key Format
map("n", "<leader>.", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format 󰘞 " })

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer 󰙅 " })

-- Which-Key Windows
map("n", "<leader>wc", "<C-W>c", { desc = "Close  ", remap = true })
map("n", "<leader>wo", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wr", "<C-W>=", { desc = "Resize 󰙖 " })
map("n", "<leader>wsh", "<C-W>s", { desc = "Horizontal  ", remap = true })
map("n", "<leader>wsv", "<C-W>v", { desc = "Vertical  ", remap = true })
map("n", "<leader>ww", "<C-W>x", { desc = "Swap 󰓡 ", remap = true })

-- Which-Key Togglers
map("n", "<leader>td", "<cmd>ToggleDiagnostic<CR>", { desc = "Diagnostic  " })
map("n", "<leader>th", "<cmd>ToggleHighlight<CR>", { desc = "Highlight 󰌁 " })
map("n", "<leader>tm", "<cmd>ToggleTerm<CR>", { desc = "Term  " })
map("n", "<leader>tr", "<cmd>ToggleRelative<CR>", { desc = "Relative  " })
map("n", "<leader>ts", "<cmd>ToggleSpell<CR>", { desc = "Spell 󰓆 " })
map("n", "<leader>tw", "<cmd>ToggleWrap<CR>", { desc = "Wrap 󰖶 " })

-- Which-Key Info
map("n", "<leader>lil", "<cmd>LspInfo<CR>", { desc = "LSP  " })
map("n", "<leader>lim", "<cmd>Mason<CR>", { desc = "Mason 󰢛 " })
map("n", "<leader>lit", "<cmd>TSModuleInfo<CR>", { desc = "Treesitter 󱖫 " })
map("n", "<leader>lin", "<cmd>NullLsInfo<CR>", { desc = "Null-LS 󱆨 " })

-- Which-Key Diagnostics
map("n", "<leader>ldf", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Float Diagnostic  " })
map("n", "<leader>ldj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic 󰮱 " })
map("n", "<leader>ldk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev Diagnostic 󰮳 " })
map("n", "<leader>ldl", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "Location List  " })
map("n", "<leader>lal", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open Float" })
