local M = { "Eandrju/cellular-automaton.nvim" }

M.enabled = true

M.cmd = { "CellularAutomaton" }

M.config = function()
  require("cellular-automaton").setup()
end

return M
