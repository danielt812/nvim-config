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

local group = vim.api.nvim_create_augroup("mini_git", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitUpdated",
  group = group,
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    local branch = summary.head_name
    if branch then
      vim.b[data.buf].minigit_summary_string = "%#MiniStatuslineGit#" .. branch .. "%#MiniStatuslineDevinfo#"
    else
      vim.b[data.buf].minigit_summary_string = nil
    end
  end,
})
