local M = { "echasnovski/mini.colors" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {}
end

M.config = function(_, opts)
  require("mini.colors").setup(opts)
end

return M
