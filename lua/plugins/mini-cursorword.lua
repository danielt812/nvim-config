local M = { "echasnovski/mini.cursorword" }

M.enabled = true

M.event = { "BufRead", "BufNew" }

M.opts = function()
  return {
    delay = 0,
  }
end

M.config = function(_, opts)
  require("mini.cursorword").setup(opts)
end

return M
