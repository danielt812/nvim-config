-- local gitblame = require("gitblame")
local blame = require("blame")

local utils = require("utils")

-- Inline
-- gitblame.setup({
--   enabled = true, -- if you want to enable the plugin
--   message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
--   date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
--   virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
-- })

-- Fugitive style
blame.setup({
  date_format = "%Y/%m/%d %H:%M", -- string - Pattern for the date
  virtual_style = "right_align", -- "right_align" or "float" - Float moves the virtual text close to the content of the file
  max_summary_width = 30,
  merge_consecutive = true,
  mappings = {
    commit_info = "i",
    stack_push = "<TAB>",
    stack_pop = "<BS>",
    show_commit = "<CR>",
    commit_detail_view = "vsplit", -- 'current' | 'tab' | 'vsplit' | 'split'
    close = { "<Esc>", "q" },
  },
})

utils.map("n", "<leader>gB", "<cmd>BlameToggle<cr>", { desc = "Blame file" })

local blame_au_group = vim.api.nvim_create_augroup("Blame group", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = blame_au_group,
  pattern = "BlameViewOpened",
  callback = function(event)
    local blame_type = event.data
    if blame_type == "window" then
      vim.opt_local.winbar = nil
      vim.opt_local.wrap = false
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = blame_au_group,
  pattern = "BlameViewClosed",
  callback = function(event)
    local blame_type = event.data
    if blame_type == "window" then
      vim.opt_local.wrap = true
    end
  end,
})
