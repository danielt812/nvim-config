local lspconfig = require("lspconfig")
local angularls_path = vim.fn.expand("$MASON/packages/angular-language-server")

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
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
  root_markers = lspconfig.util.root_pattern("angular.json", ".git"),
}
