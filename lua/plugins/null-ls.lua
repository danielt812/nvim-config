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
        "--single-quote=false",
        -- "--jsx-single-quote",
        "--prose-wrap=preserve",
        "--print-width=120",
        "--single-attribute-per-line",
      },
    }),
    formatting.shfmt.with({
      filetypes = { "zsh", "bash", "sh" },
      extra_args = { "--indent", "2" },
    }),
    formatting.stylua.with({
      extra_args = { "--config-path=stylua.toml" },
    }),
  },
})
