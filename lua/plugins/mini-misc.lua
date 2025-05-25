local M = { "echasnovski/mini.misc" }

M.enabled = true

M.keys = {
  { "<leader>ez", "<cmd>lua MiniMisc.zoom()<cr>", desc = "Zoom" },
}

M.event = { "VeryLazy" }

M.opts = function()
  return {
    -- Array of fields to make global (to be used as independent variables)
    make_global = { "put", "put_text" },
  }
end

M.config = function(_, opts)
  require("mini.misc").setup(opts)
end

return M
