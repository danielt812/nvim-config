return {
  default_config = {
    cmd = { "typescript-language-server", "--stdio" },
    filetype = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
    single_file_support = true,
  },
}
