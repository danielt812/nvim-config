local last_location_au_group = vim.api.nvim_create_augroup("last_location_au_group", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = last_location_au_group,
  desc = "Buffer last location",
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

local format_au_group = vim.api.nvim_create_augroup("format_au_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = format_au_group,
  desc = "Format on save",
  pattern = { "*.lua", "*.js", "*.jsx", "*.scss", "*.css", "*.zsh", "*.sh" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

local buffer_options_group = vim.api.nvim_create_augroup("buffer_options", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = buffer_options_group,
  desc = "Disable new line comment",
  callback = function()
    -- NOTE - :h fo-table
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

local filetype_settings_group = vim.api.nvim_create_augroup("filetype_settings_group", { clear = true })

local hide_ui_filetypes = {}
for _, ft in ipairs({ "alpha", "oil", "checkhealth", "mason", "lazy", "lazygit", "ministarter" }) do
  hide_ui_filetypes[ft] = true
end

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_settings_group,
  desc = "Hide tabline and statusline for minimal UI filetypes",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if hide_ui_filetypes[ft] then
      vim.opt_local.laststatus = 0
      vim.opt_local.showtabline = 0
    else
      vim.opt_local.laststatus = 2
      vim.opt_local.showtabline = 2
    end
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

local help_settings_group = vim.api.nvim_create_augroup("help_settings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = help_settings_group,
  desc = "Open filetypes in vertical split",
  pattern = { "help" },
  callback = function()
    vim.cmd("wincmd L")
  end,
})

local window_settings_group = vim.api.nvim_create_augroup("window_settings", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = window_settings_group,
  desc = "Resize windows evenly on screen resize",
  callback = function()
    vim.cmd("wincmd =")
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

local mini_au_group = vim.api.nvim_create_augroup("mini_au_group", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = mini_au_group,
  pattern = { "MiniStarterOpened" },
  desc = "Hide tabline when opening MiniStarter",
  callback = function()
    vim.opt_local.showtabline = 0
    vim.opt_local.laststatus = 0
    vim.opt_local.winbar = nil
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = mini_au_group,
  pattern = { "MiniPickStart", "MiniPickStop" },
  desc = "Toggle tabline when opening MiniPick",
  callback = function()
    local filetypes = {
      ministarter = false,
      oil = false,
      lazy = false,
      mason = false,
    }
    local hide_ui = false
    local win_ids = vim.api.nvim_list_wins()

    for _, win_id in ipairs(win_ids) do
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })

      if filetypes[buf_ft] ~= nil then
        hide_ui = true
        break
      end
    end

    if hide_ui then
      vim.opt_local.showtabline = 0
      vim.opt_local.winbar = nil
      vim.opt_local.laststatus = 0
    else
      vim.opt_local.showtabline = 2
      vim.opt_local.laststatus = 2
    end
  end,
})

-- vim.api.nvim_create_autocmd("CursorMovedI", {
--   group = mini_au_group,
--   callback = function()
--     local ts_parsers = require("nvim-treesitter.parsers")
--     local ts_utils = require("nvim-treesitter.ts_utils")
--
--     -- Only proceed if the buffer has a valid Tree-sitter parser
--     if not ts_parsers.has_parser() then
--       return
--     end
--
--     local node = ts_utils.get_node_at_cursor()
--     if not node then
--       return
--     end
--
--     -- Traverse up to find a parent string node
--     while node do
--       local type = node:type()
--       if type == "string" or type == "string_fragment" or type == "template_string" then
--         vim.b.minipairs_disable = true
--         return
--       end
--       node = node:parent()
--     end
--
--     -- If not inside a string, re-enable MiniPairs
--     vim.b.minipairs_disable = false
--   end,
-- })
