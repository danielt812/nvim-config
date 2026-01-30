return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
    "tsconfig.base.json",
  },
  settings = {
    diagnostics = {
      ignoredCodes = { 80001 },
    },
  },
}
