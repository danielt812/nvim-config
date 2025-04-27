local M = { "hedyhli/outline.nvim" }

M.enabled = true

M.dependencies = { "onsails/lspkind.nvim" }

M.cmd = { "Outline", "OutlineOpen" }

M.keys = {
  { "<leader>s", "<cmd>Outline<CR>", desc = "Symbols Outline 󱔁 " },
}

M.opts = function()
  return {
    symbols = {
      icon_source = "lspkind",
    },
  }
end

M.config = function(_, opts)
  require("outline").setup(opts)
end

return M
