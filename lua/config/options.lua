local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.backup = false -- Creates a backup file
opt.breakindent = true -- Indent wrapped lines
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.conceallevel = 0 -- Hide * markup for bold and italic
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " } -- disable `~` on nonexistent lines
opt.foldcolumn = "0" -- show fold column
opt.foldenable = true -- enable fold for nvim-ufo
opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
opt.foldlevelstart = 99
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
-- opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Ruler at bottom
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showcmd = false -- Silence command output
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
-- opt.statuscolumn =
--   '%=%{v:relnum?v:relnum:v:lnum}%s%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : " ") : " " }'
opt.swapfile = false -- Create a swapfile
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds)
opt.title = true -- Set the title of window to the value of the titlestring
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true -- Disable line wrap
