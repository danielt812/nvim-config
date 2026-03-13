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
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { ".git" })
    if root then cb(root) end
  end,
  single_file_support = true,
  settings = {
    toml = {
      schemas = schemas,
    },
  },
}
