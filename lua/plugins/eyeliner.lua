local M = { "jinh0/eyeliner.nvim" }

M.enabled = false

M.keys = { "f", "F" }

M.opts = function()
  return {
    highlight_on_key = true, -- show highlights only after keypress
    dim = true, -- dim all other characters if set to true (recommended!)
  }
end

M.config = function(_, opts)
  require("eyeliner").setup(opts)
end

return M
