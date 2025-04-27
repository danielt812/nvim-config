local M = { "stevearc/quicker.nvim" }

M.enabled = true

M.event = { "BufReadPre" }

M.opts = function()
  return {
    opts = {
      buflisted = false,
      number = false,
      relativenumber = false,
      signcolumn = "auto",
      winfixheight = true,
      wrap = false,
    },
  }
end

M.config = function(_, opts)
  require("quicker").setup(opts)
end

return M
