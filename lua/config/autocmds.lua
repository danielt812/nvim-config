local highlight_yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
-- Highlight yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = highlight_yank_group,
  desc = "Highlight Yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

local format_on_save_group = vim.api.nvim_create_augroup("format_on_save", { clear = true })
-- Format On Save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_on_save_group,
  desc = "Format On Save",
  pattern = { "*.lua", "*.js" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

local spell_check_group = vim.api.nvim_create_augroup("spell_check", { clear = true })
-- Set Spell Check
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = spell_check_group,
  desc = "Set Spell Check",
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

local colorscheme_switch_group = vim.api.nvim_create_augroup("colorscheme_switch", { clear = true })
-- Set Illuminate Highlight
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = colorscheme_switch_group,
  desc = "Set Illuminate Highlight",
  callback = function()
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Underlined" })
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd "hi link illuminatedWord LspReferenceText"
  end,
})

local filetype_settings_group = vim.api.nvim_create_augroup("filetype_settings", { clear = true })
-- Show Tabline
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "Show Tabline",
  pattern = { "*" },
  callback = function()
    vim.opt_local.showtabline = 2
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- Hide Tabline
  group = filetype_settings_group,
  desc = "Hide Tabline and Number",
  pattern = { "alpha", "lazy", "Telescope*", "checkhealth" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- Hide Tabline
  group = filetype_settings_group,
  desc = "Hide Tabline",
  pattern = { "oil", "mason", "lazy" },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- q To Exit
  group = filetype_settings_group,
  desc = "q To Exit",
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

-- local dir_opened_group = vim.api.nvim_create_augroup("dir_opened", { clear = true })

-- vim.api.nvim_create_autocmd({ "User" }, {
--   group = filetype_settings_group,
--   pattern = "AlphaReady", -- Replace with your desired pattern
--   desc = "disable tabline for alpha",
--   callback = function()
--     vim.opt_local.showtabline = 0
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "User" }, {
--   group = filetype_settings_group,
--   pattern = "AlphaClosed",
--   desc = "enable tabline after alpha",
--   callback = function()
--     vim.opt_local.showtabline = 2
--   end,
-- })
