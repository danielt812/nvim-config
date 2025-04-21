local M = { "echasnovski/mini.extra" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {}
end

M.config = function(_, opts)
  require("mini.extra").setup(opts)
end

return M
