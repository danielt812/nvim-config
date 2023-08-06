return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre" },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  opts = function()
    local formatting = require("null-ls").builtins.formatting
    local diagnostics = require("null-ls").builtins.diagnostics

    return {
      debug = false,
      sources = {
        formatting.prettierd.with({
          extra_filetypes = { "toml" },
          extra_args = {
            "--trailing-comma=es5",
            "--use-tabs",
            -- "--single-quote",
            "--jsx-single-quote",
            "--print-width=120",
            "--single-attribute-per-line",
          },
        }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua.with({
          extra_args = { "--config-path=stylua.toml" },
        }),
        diagnostics.flake8,
        -- diagnostics.selene,
      },
    }
  end,
  config = function(_, opts)
    require("null-ls").setup(opts)
  end,
}
