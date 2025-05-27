local mason = require("mason")

mason.setup({
  install_root_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "mason"),
  PATH = "prepend",
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
  registries = {
    "github:mason-org/mason-registry",
  },
  providers = {
    "mason.providers.registry-api",
    "mason.providers.client",
  },
  github = {
    download_url_template = "https://github.com/%s/releases/download/%s/%s",
  },
  pip = {
    upgrade_pip = false,
    install_args = {},
  },
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- stylua: ignore start
local lsp_config = require("mason-lspconfig")
local null_ls    = require("mason-null-ls")
local dap        = require("mason-nvim-dap")
-- stylua: ignore end

lsp_config.setup({
  automatic_enable = false,
  automatic_installation = true,
  ensure_installed = {
    "angularls",
    "bashls",
    "cssls",
    "emmet_language_server",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "tailwindcss",
    "ts_ls",
    "yamlls",
  },
})

null_ls.setup({
  ensure_installed = {
    "stylua",
    "prettierd",
    "shfmt",
  },
  automatic_installation = true,
})

dap.setup({
  ensure_installed = {
    "node2",
    "lua",
  },
  automatic_installation = true,
})
