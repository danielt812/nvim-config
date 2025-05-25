local M = { "hedyhli/outline.nvim" }

M.enabled = true

M.dependencies = { "onsails/lspkind.nvim" }

M.event = { "VeryLazy" }

M.cmd = { "Outline", "OutlineOpen" }

M.keys = {
  { "<leader>es", "<cmd>Outline<cr>", desc = "Symbols" },
}

M.opts = function()
  return {
    outline_window = {
      auto_jump = true,
    },
    symbols = {
      icon_source = "lspkind",
    },
  }
end

M.config = function(_, opts)
  require("outline").setup(opts)
end

return M
