local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettierd.with({
      extra_filetypes = { "toml" },
      extra_args = {
        "--trailing-comma=es5",
        "--tab-width=2",
        "--jsx-single-quote",
        "--print-width=120",
        "--single-attribute-per-line",
      },
    }),
    formatting.shfmt.with({
      filetypes = { "zsh", "bash", "sh" },
    }),
    formatting.stylua.with({
      extra_args = { "--config-path=stylua.toml" },
    }),
  },
})
