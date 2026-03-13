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
  filetypes = { "yaml" },
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { ".git" })
    if root then cb(root) end
  end,
  settings = {
    yaml = {
      schemaStore = { enable = false },
      schemas = schemas,
    },
  },
}
