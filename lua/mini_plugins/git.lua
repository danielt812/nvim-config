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

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("minigit_summary", { clear = true }),
  pattern = "MiniGitUpdated",
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or nil
  end,
})

local blame = function() vim.cmd("vertical Git blame -- %") end

-- vim.keymap.set("n", "<leader>gb", blame, { desc = "Blame" })

require("utils.git-conflict")
require("utils.git-blame")
