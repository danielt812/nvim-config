local M = { "folke/lazydev.nvim" }

M.enabled = true

M.ft = "lua"

M.cmd = "LazyDev"

M.opts = function()
  return {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
    },
  }
end

M.config = function (_, opts)
  require("lazydev").setup(opts)
end

return M
