local last_loc_group = vim.api.nvim_create_augroup("last_loc", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_loc_group,
  desc = "Buffer Last Location",
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank_group,
  desc = "Highlight on Yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
  end,
})

-- Format on save
local format_on_save_group = vim.api.nvim_create_augroup("format_on_save", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_on_save_group,
  desc = "Format On Save",
  pattern = { "*.lua", "*.js", "*.jsx", "*.json", "*.py", "*.scss", "*.css", "*.zsh", "*.sh" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- Prevent comment on new line if pressing <CR> on commented line
local buffer_options_group = vim.api.nvim_create_augroup("buffer_options", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = buffer_options_group,
  desc = "Disable New Line Comment",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
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
  desc = "Hide Tabline and disable relative number",
  pattern = {
    "alpha",
    "oil",
    "checkhealth",
    "mason",
    "lazy",
    "Telescope*",
    "lazygit",
    "notify",
    "fzf",
  },
  callback = function()
    vim.opt_local.showtabline = 0
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = filetype_settings_group,
  desc = "q To Exit Filetype",
  pattern = {
    "blame",
    "checkhealth",
    "help",
    "lsp-installer",
    "lspinfo",
    "man",
    "null-ls-info",
    "qf",
    "tsplayground",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true })
    vim.opt_local.buflisted = true
  end,
})

-- Open help in vertical split instead of horizontal
local help_settings_group = vim.api.nvim_create_augroup("help_settings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = help_settings_group,
  desc = "Open filetypes in vertical split",
  pattern = {
    "help",
    "markdown",
  },
  callback = function()
    vim.api.nvim_command("wincmd L")
  end,
})

-- Set illuminate highlight to underline
local illuminate_highlight_group = vim.api.nvim_create_augroup("illuminate_highlight", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
  group = illuminate_highlight_group,
  desc = "Set Illuminate Highlight",
  callback = function()
    vim.api.nvim_set_hl(0, "IlluminatedWord", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Underlined" })
  end,
})

-- Use illuminate instead of lsp highlight
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = illuminate_highlight_group,
  desc = "Set Illuminate Highlight on LspAttach",
  callback = function()
    vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Underlined" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "@lsp.type.comment", {}) -- https://github.com/stsewd/tree-sitter-comment/issues/22
  end,
})

-- Set winbar for DAP UI
local winbar_settings_group = vim.api.nvim_create_augroup("winbar_settings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = winbar_settings_group,
  desc = "Winbar settings determined by buffer filetype",
  pattern = { "*" },
  callback = function()
    local win_ids = vim.api.nvim_list_wins()
    -- Iterate through each window ID and check the filetype of its associated buffer
    for _, win_id in ipairs(win_ids) do
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
      if buf_ft == "dapui_breakpoints" then
        vim.wo[win_id].winbar = "DAP Breakpoints  "
      elseif buf_ft == "dapui_stacks" then
        vim.wo[win_id].winbar = "DAP Stacks  "
      elseif buf_ft == "dapui_scopes" then
        vim.wo[win_id].winbar = "DAP Scopes  "
      elseif buf_ft == "dapui_watches" then
        vim.wo[win_id].winbar = "DAP Watches 󰂥 "
      elseif buf_ft == "dapui_console" then
        vim.wo[win_id].winbar = "DAP Console  "
      end
    end
    vim.api.nvim_set_hl(0, "WinBar", { link = "Character" })
    vim.api.nvim_set_hl(0, "WinBarNC", { link = "Character" })
  end,
})
