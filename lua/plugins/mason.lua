local M = { "mason-org/mason.nvim", version = "1.11.0" }

M.enabled = true

M.dependencies = {
  { "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
  "jay-babu/mason-null-ls.nvim",
  "jay-babu/mason-nvim-dap.nvim",
}

M.event = { "VeryLazy" }

M.cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" }

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
    null_ls = {
      ensure_installed = require("sources"),
      automatic_installation = true,
    },
  }
end

M.config = function(_, opts)
  require("mason").setup(opts.mason)

  require("mason-lspconfig").setup(opts.lsp)

  require("mason-nvim-dap").setup(opts.dap)

  require("mason-null-ls").setup(opts.null_ls)
end

return M
