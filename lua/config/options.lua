local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.conceallevel = 0 -- Hide * markup for bold and italic
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " }
opt.foldcolumn = "0" -- show fold column
opt.foldenable = true -- enable fold for nvim-ufo
opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
opt.foldlevelstart = 99
opt.formatoptions = "jcroqlnt" -- tcqj
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.relativenumber = true -- Relative line numbers
-- opt.scrolloff = 50 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.showcmd = false -- Silence command output
opt.sidescrolloff = 8 -- Columns of context
opt.spelllang = { "en" }
-- opt.statuscolumn = "%s%l %r"
-- opt.showtabline = 0
-- opt.statuscolumn =
--   '%=%{v:relnum?v:relnum:v:lnum}%s%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : " ") : " " }'
opt.swapfile = false -- Create a swapfile
opt.tabstop = 2 -- Number of spaces tabs count for
opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds)
opt.title = true -- Set the title of window to the value of the titlestring
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true -- Disable line wrap

opt.shortmess:append({ W = true, I = true, c = true, S = true })
