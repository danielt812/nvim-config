local M = { "JoosepAlviste/nvim-ts-context-commentstring" }

M.enabled = true

M.opts = function()
  return {
    enable_autocmd = false,
  }
end

M.config = function(_, opts)
  require("ts_context_commentstring").setup(opts)
end

return M
