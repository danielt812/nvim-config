local M = { "MagicDuck/grug-far.nvim" }

M.enabled = true

M.keys = {
  { "<leader>eg", "<cmd>GrugFar<cr>", desc = "GrugFar" },
}

M.cmd = { "GrugFar" }

M.opts = function()
  return {}
end

M.config = function(_, opts)
  require("grug-far").setup(opts)
end

return M
