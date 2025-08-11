local uv = vim.uv or vim.loop
local lspconfig = require("lspconfig")
local util = lspconfig.util

-- Recursively look up to find a folder with angular.json
local function find_angular_root(start)
  return util.search_ancestors(start, function(path)
    local angular_json = util.path.join(path, "angular.json")
    return uv.fs_stat(angular_json) and path or nil
  end)
end

local project_root = uv.cwd()
local angular_root = find_angular_root(project_root) or project_root

local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  angular_root,
  "--ngProbeLocations",
  angular_root,
}

return {
  cmd = cmd,
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
  root_markers = lspconfig.util.root_pattern("angular.json", ".git"),
}
