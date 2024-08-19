local M = { "folke/lazydev.nvim" }

M.enabled = true

M.ft = { "lua" }

M.opts = function()
  return {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  }
end

M.config = function(_, opts)
  require("lazydev").setup(opts)
end

return M
