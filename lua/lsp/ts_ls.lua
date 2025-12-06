return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    ".git",
    "jsconfig.json",
    "package.json",
    "tsconfig.json",
  },
  init_options = { hostInfo = "neovim" },
  single_file_support = true,
  settings = {
    diagnostics = {
      ignoredCodes = { 80001 },
    },
  },
}
