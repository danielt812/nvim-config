local M = { "nvim-treesitter/nvim-treesitter-textobjects" }

M.enabled = true

M.event = { "BufRead", "BufNewFile" }

M.opts = function()
  return {
    textobjects = {
      move = {
        enable = false,
      },
    },
  }
end

M.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
end

return M
