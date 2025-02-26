local M = { "williamboman/mason.nvim" }

M.enabled = true

M.dependencies = {
  "williamboman/mason-lspconfig.nvim",
  "jay-babu/mason-null-ls.nvim",
  "jay-babu/mason-nvim-dap.nvim",
}

M.event = { "VeryLazy" }

M.cmd = {
  "Mason",
  "MasonInstall",
  "MasonUninstall",
  "MasonUninstallAll",
  "MasonLog",
  "MasonUpdate",
}

M.keys = {
  { "<leader>lim", "<cmd>Mason<cr>", desc = "Mason 󰢛 " },
}

M.opts = function()
  return {
    mason = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    lsp = {
      ensure_installed = require("servers"),
      automatic_installation = true,
    },
    dap = {
      ensure_installed = require("adapters"),
      automatic_installation = true,
    },
    null = {
      ensure_installed = require("sources"),
      automatic_installation = true,
    },
  }
end

M.config = function(_, opts)
  require("mason").setup(opts.mason)

  require("mason-lspconfig").setup(opts.lsp)

  require("mason-nvim-dap").setup(opts.dap)

  require("mason-null-ls").setup(opts.null)
end

return M
