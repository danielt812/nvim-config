local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Which-Key Buffers
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin  " })

map("n", "<leader>bgl", "<cmd>BufferLineCycleNext<CR>", { desc = "Next 󰮱 " })
map("n", "<leader>bgh", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev 󰮳 " })
map("n", "<leader>bgp", "<cmd>BufferLinePick<CR>", { desc = "Pick  " })

map("n", "<leader>bcc", "<cmd>BufferClose<CR>", { desc = "Current  " })
map("n", "<leader>bch", "<cmd>BufferLineCloseLeft<CR>", { desc = "Left 󰳞 " })
map("n", "<leader>bcp", "<cmd>BufferLinePickClose<CR>", { desc = "Prev  " })
map("n", "<leader>bcl", "<cmd>BufferLineCloseRight<CR>", { desc = "Right 󰳠 " })
map("n", "<leader>bco", "<cmd>BufferLineCloseOthers<CR>", { desc = "Others  " })
map("n", "<leader>bcp", "<cmd>BufferLineGroupClose pinned<CR>", { desc = "Pinned 󰤱 " })
map("n", "<leader>bcu", "<cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Unpinned 󰤰 " })
map("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", { desc = "Directory   " })
map("n", "<leader>bsl", "<cmd>BufferLineSortByExtension<CR>", { desc = "Language  " })

-- Which-Key Windows
map("n", "<leader>wc", "<C-W>c", { desc = "Close  ", remap = true })
map("n", "<leader>wo", "<C-W>p", { desc = "Other 󰁁 ", remap = true })
map("n", "<leader>wr", "<C-W>=", { desc = "Resize 󰙖 " })
map("n", "<leader>wsh", "<C-W>s", { desc = "Horizontal  ", remap = true })
map("n", "<leader>wsv", "<C-W>v", { desc = "Vertical  ", remap = true })
map("n", "<leader>ww", "<C-W>x", { desc = "Swap 󰓡 ", remap = true })

-- Which-Key Replace
map("n", "<leader>rf", "<cmd>lua require('spectre').open_file_search()<CR>", { desc = "File 󰱽  " })
map("n", "<leader>rp", "<cmd>lua require('spectre').open_visual()<CR>", { desc = "Project   " })
map("n", "<leader>rwf", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", { desc = "File 󰱽 " })
map("n", "<leader>rwp", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { desc = "Project   " })

-- Which-Key Togglers
map("n", "<leader>ta", "<cmd>AerialToggle<CR>", { desc = "Aerial  " })
map("n", "<leader>td", "<cmd>ToggleDiagnostic<CR>", { desc = "Diagnostic  " })
map("n", "<leader>th", "<cmd>ToggleHighlight<CR>", { desc = "Highlight 󰌁 " })
map("n", "<leader>ti", "<cmd>Twilight<CR>", { desc = "Twilight 󰖚 " })
map("n", "<leader>tm", "<cmd>ToggleTerm<CR>", { desc = "Term  " })
map("n", "<leader>tn", "<cmd>AerialNavToggle<CR>", { desc = "Navigation 󰆌 " })
map("n", "<leader>tr", "<cmd>ToggleRelative<CR>", { desc = "Relative  " })
map("n", "<leader>ts", "<cmd>ToggleSpell<CR>", { desc = "Spell 󰓆 " })
map("n", "<leader>tw", "<cmd>ToggleWrap<CR>", { desc = "Wrap 󰖶 " })
map("n", "<leader>tz", "<cmd>ZenMode<CR>", { desc = "Zen Mode 󱅼 " })

-- map("n", "<leader>oo", "<cmd>ChatGPT<CR>", { desc = "ChatGPT 󱜹 " })

-- Which-Key Lsp Info
map("n", "<leader>lil", "<cmd>LspInfo<CR>", { desc = "LSP  " })
map("n", "<leader>lim", "<cmd>Mason<CR>", { desc = "Mason 󰢛 " })
map("n", "<leader>lin", "<cmd>NullLsInfo<CR>", { desc = "Null-LS 󱆨 " })
map("n", "<leader>lit", "<cmd>TSModuleInfo<CR>", { desc = "Treesitter 󱖫 " })

-- Which-Key Diagnostics
map("n", "<leader>ldf", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Float Diagnostic  " })
map("n", "<leader>ldj", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next Diagnostic 󰮱 " })
map("n", "<leader>ldk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Prev Diagnostic 󰮳 " })
map("n", "<leader>ldl", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "Location List  " })
map("n", "<leader>lal", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open Float" })

-- Which-Key Telescope
-- map("n", "<leader>fb", "<cmd>Telescope git_branches<CR>", { desc = "Checkout Branch " })
-- map("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Colorscheme " })
-- map("n", "<leader>fd", "<cmd>Telescope commands<CR>", { desc = "Commands " })
-- map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "File 󰱽" })
-- map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep " })
-- map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help 󰘥" })
-- map("n", "<leader>fH", "<cmd>Telescope highlights<CR>", { desc = "Highlight Groups 󰸱" })
-- map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps " })
-- map("n", "<leader>fl", "<cmd>Telescope resume<CR>", { desc = "Resume Last Search " })
-- map("n", "<leader>fm", "<cmd>Telescope man_pages<CR>", { desc = "Man Pages 󱗖" })
-- map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent File " })
-- map("n", "<leader>fR", "<cmd>Telescope registers<CR>", { desc = "Registers " })
-- map("n", "<leader>fs", "<cmd>Telescope spell_suggest<CR>", { desc = "Spelling Suggestions 󰓆" })
-- map("n", "<leader>ft", "<cmd>Telescope grep_string<CR>", { desc = "Text " })
-- map("n", "<leader>fy", "<cmd>Telescope yank_history<CR>", { desc = "Yank History 󰆒 " })
--
-- map("n", "<leader>lfb", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Buffer Diagnostics  " })
-- map("n", "<leader>lfd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics  " })
-- map("n", "<leader>lfe", "<cmd>Telescope lsp_definitions<CR>", { desc = "Definitions  " })
-- map("n", "<leader>lfq", "<cmd>Telescope quickfix<CR>", { desc = "Quickfix   " })
-- map("n", "<leader>lfr", "<cmd>Telescope lsp_references<CR>", { desc = "References  " })
-- map("n", "<leader>lfu", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document Symbols 󱪚 " })
-- map("n", "<leader>lfw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Workspace Symbols 󱈹 " })
-- map("n", "<leader>bgf", "<cmd>Telescope buffers previewer=true<CR>", { desc = "Find  " })

-- Which-Key DAP
map("n", "<leader>dsb", "<cmd>lua require('dap').step_back()<CR>", { desc = "Back  " })
map("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>", { desc = "Into  " })
map("n", "<leader>dso", "<cmd>lua require('dap').step_over()<CR>", { desc = "Over  " })
map("n", "<leader>dst", "<cmd>lua require('dap').step_out()<CR>", { desc = "Out  " })

map("n", "<leader>drt", "<cmd>lua require('dap').repl.toggle()<CR>", { desc = "Toggle Repl  " })
map("n", "<leader>drr", "<cmd>lua require('dap').repl.toggle()<CR>", { desc = "Run Last  " })

map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Breakpoint  " })
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue  " })
map("n", "<leader>dd", "<cmd>lua require('dap').disconnect()<CR>", { desc = "Disconnect  " })
map("n", "<leader>dp", "<cmd>lua require('dap').pause()<CR>", { desc = "Pause  " })
map("n", "<leader>dq", "<cmd>lua require('dap').close()<CR>", { desc = "Quit  " })
-- map("n", "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Run To Cursor 󰆿 " })

map("n", "<leader>du", "<cmd>lua require('dapui').toggle({reset = true})<CR>", { desc = "UI  " })
-- map("n", "<leader>ds", "<cmd>lua require('dap').session()<CR>", { desc = "" })
