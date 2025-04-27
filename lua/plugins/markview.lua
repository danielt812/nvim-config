local M = { "OXY2DEV/markview.nvim" }

M.enabled = true

M.ft = { "markdown" }

M.config = function()
  require("markview").setup()
end

return M
