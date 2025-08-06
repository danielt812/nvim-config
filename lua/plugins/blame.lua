local blame = require("blame")

local utils = require("utils")

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

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("User", {
  group = augroup("git-blame", { clear = true }),
  pattern = "BlameViewOpened",
  callback = function(event)
    local blame_type = event.data
    if blame_type == "window" then
      vim.opt_local.winbar = nil
      vim.opt_local.wrap = false
    end
  end,
})

au("User", {
  group = augroup("git-blame", { clear = true }),
  pattern = "BlameViewClosed",
  callback = function(event)
    local blame_type = event.data
    if blame_type == "window" then
      vim.opt_local.wrap = true
    end
  end,
})

utils.map("n", "<leader>gf", "<cmd>BlameToggle<cr>", { desc = "Blame file" })
