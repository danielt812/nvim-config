local highlight_yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = highlight_yank_group,
  desc = "Highlight Yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

local format_on_save_group = vim.api.nvim_create_augroup("format_on_save", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_on_save_group,
  desc = "Format On Save",
  pattern = { "*.lua", "*.js" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

local spell_check_group = vim.api.nvim_create_augroup("spell_check", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = spell_check_group,
  desc = "Set Spell Check",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

local illuminate_highlight_group = vim.api.nvim_create_augroup("illuminate_highlight", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = illuminate_highlight_group,
  desc = "Set Illuminate Highlight on colorscheme change",
  callback = function()
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Underlined" })
  end,
})

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = illuminate_highlight_group,
  desc = "Set Illuminate Highlight on LspAttach",
  callback = function()
    vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = illuminate_highlight_group,
  desc = "Set Illuminate Highlight on BufEnter",
  callback = function()
    vim.api.nvim_set_hl(0, "illuminatedWord", { link = "Underlined" })
  end,
})

local filetype_settings_group = vim.api.nvim_create_augroup("filetype_settings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "Show Tabline",
  pattern = { "*" },
  callback = function()
    vim.opt_local.showtabline = 2
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "Hide Tabline and Number",
  pattern = { "alpha", "lazy", "checkhealth" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "Hide Tabline",
  pattern = { "oil", "mason", "Telescope*", "lazy" },
  callback = function()
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "q To Exit Filetype",
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "lsp-installer",
    "null-ls-info",
    "tsplayground",
    "checkhealth",
    "spectre_panel",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
    vim.opt_local.buflisted = true
  end,
})
