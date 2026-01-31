local registry = require("schemas.registry")

local schemas = {
  kubernetes = {
    "**/kubernetes*.yaml",
    "**/kubernetes*.yml",
    "kubernetes*.yaml",
    "kubernetes*.yml",
  },
}

for _, schema in ipairs(registry) do
  if schema.url and schema.yaml then
    schemas[schema.url] = schema.yaml
  end
end

return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemaStore = { enable = false },
      schemas = schemas,
    },
  },
}
