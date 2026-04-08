return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
    if root then cb(root) end
  end,
  init_options = { hostInfo = "neovim" },
  single_file_support = true,
  settings = {
    diagnostics = {
      ignoredCodes = { 80001, 80005 },
    },
    typescript = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
    },
    javascript = {
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
    },
  },
}
