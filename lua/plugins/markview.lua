local M = { "OXY2DEV/markview.nvim" }

M.enabled = false

M.ft = { "markdown" }

M.config = function()
  require("markview").setup()
end

return M
