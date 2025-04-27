local M = { "echasnovski/mini-git" }

M.enabled = false

M.event = { "BufReadPost" }

M.opts = function()
  return {
    -- General CLI execution
    job = {
      -- Path to Git executable
      git_executable = "git",

      -- Timeout (in ms) for each job before force quit
      timeout = 30000,
    },

    -- Options for `:Git` command
    command = {
      -- Default split direction
      split = "auto",
    },
  }
end

M.config = function(_, opts)
  require("mini.git").setup(opts)
end

return M
