local M = { "akinsho/git-conflict.nvim" }

M.enabled = true

M.event = { "BufRead" }

M.opts = function()
  return {
    default_mappings = false, -- disable buffer local mapping created by this plugin
    default_commands = true, -- disable commands created by this plugin
    disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    highlights = { -- They must have background color, otherwise the default color will be used
      incoming = "DiffAdd",
      current = "DiffText",
    },
  }
end

M.config = function(_, opts)
  require("git-conflict").setup(opts)

  local git_conflict_group = vim.api.nvim_create_augroup("git_conflict_keybinds", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = git_conflict_group,
    desc = "Bind Git Conflict Keymaps",
    pattern = { "GitConflictDetected" },
    callback = function()
      vim.keymap.set("n", "<leader>gca", "<Plug>(git-conflict-ours)", { desc = "Accept Changes 󰯭 " })
      vim.keymap.set("n", "<leader>gci", "<Plug>(git-conflict-theirs)", { desc = "Incoming Changes 󰰅 " })
      vim.keymap.set("n", "<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Both Changes 󰯰 " })
      vim.keymap.set("n", "<leader>gcn", "<Plug>(git-conflict-none)", { desc = "No Changes 󰰔 " })
      vim.keymap.set("n", "]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
      vim.keymap.set("n", "[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
    end,
  })
end

return M
