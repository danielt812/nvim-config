return {
  "Eandrju/cellular-automaton.nvim",
  cmd = { "CellularAutomaton" },
  config = function()
    require("cellular-automaton").setup()
  end,
}
