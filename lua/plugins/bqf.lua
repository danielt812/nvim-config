local M = { "kevinhwang91/nvim-bqf" }

M.enabled = false

M.ft = { "qf" }

M.config = function()
  require("bqf").setup({})
end

return M
