local M = { "echasnovski/mini.jump" }

M.enabled = false

M.keys = { "f", "F", "t", "T" }

M.event = { "VeryLazy" }

M.opts = function()
  return {
    mappings = {
      forward = "f",
      backward = "F",
      forward_till = "t",
      backward_till = "T",
      repeat_jump = ";",
    },
    delay = {
      highlight = 0,
    },
  }
end

M.config = function(_, opts)
  require("mini.jump").setup(opts)
end

return M
