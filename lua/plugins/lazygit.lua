local M = { "kdheepak/lazygit.nvim" }

M.enabled = true

M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
}

M.cmd = {
  "LazyGit",
  "LazyGitCurrentFile",
  "LazyGitConfig",
  "LazyGitFilter",
  "LazyGitFilterCurrentFile",
}

M.config = function()
  require("telescope").load_extension("lazygit")
end

return M
