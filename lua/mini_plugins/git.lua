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

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local au_group = vim.api.nvim_create_augroup("mini_git", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitUpdated",
  group = au_group,
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or nil
  end,
})
