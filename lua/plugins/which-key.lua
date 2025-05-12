local M = { "folke/which-key.nvim" }

M.enabled = false

M.event = { "VeryLazy" }

M.dependencies = {
  -- "nvim-tree/nvim-web-devicons",
  "echasnovski/mini.icons",
}

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
      { "<leader>.", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format 󰘞 " },
      { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard 󰨝 " },
      { "<leader>c", "<cmd>BufferClose<cr>", desc = "Close Buffer 󰅚 " },
      { "<leader>b", group = "Buffer  " },
      { "<leader>bc", group = "Close  " },
      { "<leader>bg", group = "Go To   " },
      { "<leader>f", group = "Find  " },
      { "<leader>g", group = "Git  " },
      { "<leader>gh", group = "Hunk 󰦨 " },
      { "<leader>gt", group = "Toggle 󰨚 " },
      { "<leader>l", group = "LSP  " },
    },
  }
end

M.config = function(_, opts)
  require("which-key").setup(opts.plugin)
  require("which-key").add(opts.map)
end

return M
