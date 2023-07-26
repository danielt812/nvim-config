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
  pattern = { "*.lua" },
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

local startup_group = vim.api.nvim_create_augroup("startup", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  -- Hide Tabline
  group = startup_group,
  desc = "Hide Tabline",
  callback = function(bufnr)
    vim.opt_local.showtabline = 0
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
  pattern = { "lir", "alpha", "lazy", "Telescope*", "checkhealth" },
  callback = function(bufnr)
    vim.opt_local.number = false
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- Hide Tabline
  group = filetype_settings_group,
  desc = "Hide Tabline",
  pattern = { "oil" },
  callback = function(bufnr)
    vim.opt_local.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  -- Q To Exit
  group = filetype_settings_group,
  desc = "Q To Exit",
  pattern = {
    "qf",
    "help",
    "man",
    "lspinfo",
    "lsp-installer",
    "null-ls-info",
    "tsplayground",
    "checkhealth",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    vim.opt_local.buflisted = true
  end,
})

-- local dir_opened_group = vim.api.nvim_create_augroup("dir_opened", { clear = true })

-- Function to set the 'buftype' option for directory buffers
-- Open Nvim-Tree if the opened buffer is a directory
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   group = dir_opened_group,
--   callback = function()

--     local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
--     if stats and stats.type == "directory" then
--       vim.cmd("NvimTreeOpen")
--     end
--   end,
-- })

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

-- vim.api.nvim_create_autocmd('LspAttach', {
--   desc = 'LSP actions',
--   callback = function()
--     local bufmap = function(mode, lhs, rhs)
--       local opts = {buffer = true}
--       vim.keymap.set(mode, lhs, rhs, opts)
--     end

--     -- Displays hover information about the symbol under the cursor
--     bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

--     -- Jump to the definition
--     bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

--     -- Jump to declaration
--     bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

--     -- Lists all the implementations for the symbol under the cursor
--     bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

--     -- Jumps to the definition of the type symbol
--     bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

--     -- Lists all the references
--     bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

--     -- Displays a function's signature information
--     bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

--     -- Renames all references to the symbol under the cursor
--     bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

--     -- Selects a code action available at the current cursor position
--     bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
--     bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

--     -- Show diagnostics in a floating window
--     bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

--     -- Move to the previous diagnostic
--     bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

--     -- Move to the next diagnostic
--     bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
--   end
-- })
