-- stylua: ignore start
-- INFO: File handling
vim.opt.backup         = false -- Disable backup files
vim.opt.swapfile       = false -- Disable swap files
vim.opt.undofile       = true -- Persistent undo
vim.opt.writebackup    = false -- Disable backup before overwrite

-- INFO: Editing behavior
vim.opt.autoindent     = true -- Copy indent from current line
vim.opt.breakindent    = true -- Preserve indentation on wrapped lines
vim.opt.expandtab      = true -- Use spaces instead of tabs
vim.opt.linebreak      = true -- Wrap at word boundaries
vim.opt.mouse          = "a" -- Enable mouse support
vim.opt.shiftwidth     = 2 -- Spaces per indent step
vim.opt.smartindent    = true -- Make indenting smart
vim.opt.tabstop        = 2 -- Visual width of a tab

-- INFO: Search and grep
vim.opt.grepprg        = "rg --vimgrep" -- Use ripgrep.rc config
vim.opt.ignorecase     = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch      = true -- Show search results while typing
vim.opt.smartcase      = true -- Don't ignore case when searching if pattern has upper case

-- INFO: Completion
vim.opt.completeopt    = "menuone,noselect,fuzzy" -- Completion popup behavior
vim.opt.infercase      = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.pumheight      = 10 -- Max popup menu height

-- INFO: UI and display
vim.opt.cursorline     = true -- Highlight current line
vim.opt.fillchars      = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " } -- Custom UI glyphs
vim.opt.list           = true -- Show invisible characters
vim.opt.number         = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.ruler          = false -- Don't show cursor position in command line
vim.opt.scrolloff      = 10 -- Keep context lines above/below cursor
vim.opt.showmode       = false -- Don't show mode in command line
vim.opt.signcolumn     = "yes" -- Always show sign column (otherwise it will shift text)
vim.opt.winborder      = "rounded" -- Use rounded floating window borders
vim.opt.wrap           = false -- Display long lines as just one line

-- INFO: Window splits
vim.opt.splitbelow     = true -- Horizontal splits will be below
vim.opt.splitright     = true -- Vertical splits will be to the right

-- INFO: Folding
vim.opt.foldcolumn     = "0" -- Hide dedicated fold column
vim.opt.foldenable     = true -- Enable folding
vim.opt.foldlevel      = 99 -- Open folds up to this level
vim.opt.foldlevelstart = 99 -- Start with folds open

-- INFO: System and performance
vim.opt.clipboard      = "unnamedplus" -- Sync with system clipboard
vim.opt.updatetime     = 1000 -- CursorHold and swap write interval (ms)
vim.opt.shortmess:append("S") -- Don't show search count
-- stylua: ignore end
