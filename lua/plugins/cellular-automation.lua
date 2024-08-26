local M = { "Eandrju/cellular-automaton.nvim" }

M.enabled = true

M.cmd = { "CellularAutomaton" }

M.init = function()
	vim.api.nvim_create_user_command("FML", function()
		vim.api.nvim_command("CellularAutomaton make_it_rain")
	end, {})
end

return M
