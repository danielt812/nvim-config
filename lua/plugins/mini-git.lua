local M = { "echasnovski/mini-git" }

M.enabled = true

M.event = { "VeryLazy" }

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

  -- local minigit_settings_group = vim.api.nvim_create_augroup("minigit_settings_group", { clear = true })
  -- vim.api.nvim_create_autocmd("User", {
  --   group = minigit_settings_group,
  --   pattern = "MiniGitUpdated",
  --   callback = function(data)
  --     local summary = vim.b[data.buf].minigit_summary
  --     vim.b[data.buf].minigit_summary_string = summary.head_name or ""
  --   end,
  -- })
end

return M
