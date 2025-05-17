local M = { "leath-dub/snipe.nvim" }

M.enabled = true

M.event = { "BufReadPost" }

M.keys = {
  {
    "<leader>bs",
    "<cmd>lua require('snipe').open_buffer_menu()<cr>",
    desc = "Select",
  },
}
M.opts = function()
  return {}
end

M.config = function(_, opts)
  require("snipe").setup(opts)
end

return M
