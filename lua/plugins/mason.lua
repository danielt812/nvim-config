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

local ensure_installed = {
  -- LSP
  "angular-language-server",
  "basedpyright",
  "bash-language-server",
  "css-lsp",
  "cssmodules-language-server",
  "emmet-language-server",
  "eslint-lsp",
  "gopls",
  "html-lsp",
  "json-lsp",
  "lua-language-server",
  "tailwindcss-language-server",
  "tsgo",
  "typescript-language-server",
  "yaml-language-server",
  -- Formatters/Linters
  "prettierd",
  "shfmt",
  "stylua",
  -- DAP
  "js-debug-adapter",
}

local installed_package_names = require("mason-registry").get_installed_package_names()

for _, pkg in pairs(ensure_installed) do
  if not vim.tbl_contains(installed_package_names, pkg) then
    vim.cmd("MasonInstall " .. pkg)
  end
end
