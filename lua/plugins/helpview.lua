local M = { "OXY2DEV/helpview.nvim" }

M.enabled = true

M.ft = { "help" }

M.config = function()
	require("helpview").setup()
end

return M
