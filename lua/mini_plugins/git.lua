local git = require("mini.git")

git.setup({
  job = {
    git_executable = "git",
    timeout = 30000,
  },
  command = {
    split = "auto",
  },
})

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("User", {
  group = augroup("minigit_summary", { clear = true }),
  pattern = "MiniGitUpdated",
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or nil
  end,
})
