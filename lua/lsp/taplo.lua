local registry = require("schemas.registry")

local schemas = {}

for _, schema in ipairs(registry) do
  if schema.toml then
    table.insert(schemas, {
      name = schema.name,
      description = schema.description,
      url = schema.url,
      fileMatch = schema.toml,
    })
  end
end

return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { ".git" },
  single_file_support = true,
  settings = {
    toml = {
      schemas = schemas,
    },
  },
}
