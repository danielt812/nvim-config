local registry = require("schemas.registry")

local schemas = {}

for _, schema in ipairs(registry) do
  if schema.name and schema.url and schema.json then
    table.insert(schemas, {
      name = schema.name,
      url = schema.url,
      fileMatch = schema.json,
    })
  end
end

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  init_options = {
    provideFormatter = false,
  },
  single_file_support = true,
  settings = {
    json = {
      schemas = schemas,
      validate = { enable = true },
    },
  },
}
