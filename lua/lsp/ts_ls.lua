return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
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
