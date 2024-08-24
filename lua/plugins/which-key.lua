local M = { "folke/which-key.nvim" }

M.enabled = true

M.event = { "VeryLazy" }

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.opts = function()
  return {
    plugin = {
      preset = "classic", -- classic | modern | helix
      delay = 0,
      disable = {
        ft = { "alpha" },
      },
      icons = {
        mappings = false,
      },
    },
    map = {
      { "<leader>.", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
      { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard" },
      { "<leader>c", "<cmd>BufferClose<cr>", desc = "Close Buffer" },
      { "<leader>f", group = "file" },
      { "<leader>g", group = "git" },
      { "<leader>x", group = "trouble" },
    },
  }
end

M.config = function(_, opts)
  require("which-key").setup(opts.plugin)
  require("which-key").add(opts.map)
end

return M
