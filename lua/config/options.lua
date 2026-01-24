vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noselect,fuzzy"
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.updatetime = 1000
vim.opt.winborder = "rounded"

vim.opt.grepprg =  "rg --vimgrep -u --glob '!.git/*' --glob '!node_modules/*' --glob '!.angular/*'"

vim.opt.foldcolumn = "0"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99


vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " }

vim.opt.guicursor:append("a:blinkon500-blinkoff500")
vim.opt.shortmess:append("S")
