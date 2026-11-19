return {
  cmd = { "tsc", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "tsconfig.json", "jsconfig.json", "package.json", "tsconfig.base.json", ".git" })
    if root then cb(root) end
  end,
  single_file_support = true,
  settings = {
    diagnostics = {
      ignoredCodes = { 80001 },
    },
    -- typescript = {
    --   referencesCodeLens = { enabled = true },
    --   implementationsCodeLens = { enabled = true },
    -- },
    -- javascript = {
    --   referencesCodeLens = { enabled = true },
    --   implementationsCodeLens = { enabled = true },
    -- },
  },
}
