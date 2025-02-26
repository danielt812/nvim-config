local lspconfig = require("lspconfig")
local mason_registry = require("mason-registry")
local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

-- https://github.com/mason-org/mason-registry/blob/2025-02-25-lame-hole/packages/angular-language-server/package.yaml
-- MasonInstall angular-language-server@{@angular/cli version}

local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  table.concat({
    angularls_path,
    vim.uv.cwd(),
  }, ","),
  "--ngProbeLocations",
  table.concat({
    angularls_path .. "/node_modules/@angular/language-server",
    vim.uv.cwd(),
  }, ","),
}

return {
  cmd = cmd,
  root_dir = lspconfig.util.root_pattern("angular.json", ".git"),
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = cmd
  end,
}
