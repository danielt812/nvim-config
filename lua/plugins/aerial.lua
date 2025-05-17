local M = { "stevearc/aerial.nvim" }

M.enabled = false

M.cmd = { "Aerial" }

M.opts = function()
  return {
    autojump = true,
  }
end

M.config = function(_, opts)
  require("aerial").setup(opts)
end
return M
