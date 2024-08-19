local M = { "echasnovski/mini.animate" }

M.enabled = false

M.event = { "BufReadPre" }

M.opts = function()
  return {
    scroll = {
      enable = true,
    },
  }
end

M.config = function(_, opts)
  require("mini.animate").setup(opts)
end

return M
