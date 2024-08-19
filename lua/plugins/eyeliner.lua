local M = { "jinh0/eyeliner.nvim" }

M.enabled = true

M.event = { "BufRead" }

M.opts = function()
  return {
    highlight_on_key = true, -- show highlights only after keypress
    dim = true, -- dim all other characters if set to true (recommended!)
    disable_buftypes = { "Alpha" },
    default_keymaps = true,
  }
end

M.config = function(_, opts)
  require("eyeliner").setup(opts)
end

return M
