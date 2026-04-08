return {
  cmd = { "tsgo", "--lsp", "--stdio" },
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
  settings = {
    diagnostics = {
      ignoredCodes = { 80001 },
    },
  },
}
