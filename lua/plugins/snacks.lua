local M = { "folke/snacks.nvim" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = true },
    explorer = { enabled = false },
    lazygit = { enabled = true },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    zen = {
      enabled = true,
      fullscreen = true,
    },
  }
end

M.config = function(_, opts)
  require("snacks").setup(opts)
end

return M
