local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.enabled = false

M.ft = { "markdown" }

M.config = function()
  require("render-markdown").setup()
end

return M
