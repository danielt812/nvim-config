local M = { "shellRaining/hlchunk.nvim" }

M.enabled = true

M.event = { "BufReadPre", "BufNewFile" }

M.opts = function()
  return {
    chunk = {
      enable = true,
      style = {
        { fg = "#ffffff" },
        { fg = "#c21f30" },
      },
    },
    indent = {
      enable = true,
    },
  }
end

M.config = function(_, opts)
  require("hlchunk").setup(opts)
end

return M
