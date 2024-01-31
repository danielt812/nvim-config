return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local formatting = require("null-ls").builtins.formatting
    local diagnostics = require("null-ls").builtins.diagnostics

    local dotfiles = vim.fn.getenv("DOTFILES")

    return {
      debug = false,
      sources = {
        formatting.prettierd.with({
          extra_filetypes = { "toml" },
          extra_args = {
            "--trailing-comma=es5",
            -- "--use-tabs",
            -- "--tab-width=2",
            -- "--single-quote",
            "--jsx-single-quote",
            "--print-width=120",
            "--single-attribute-per-line",
          },
        }),
        -- formatting.biome.with({
        --   extra_args = {
        --     "--trailing-comma=es5",
        --     "--indent-style=space",
        --     "--indent-width=2",
        --     "--jsx-quote-style=single",
        --     "--line-width=120",
        --     "--semicolons=always",
        --   },
        -- }),
        formatting.beautysh.with({
          extra_args = {
            "--indent-size",
            "2",
            "--force-function-style",
            "paronly", -- fnpar: function foo(), fnonly: function foo, paronly: foo()
          },
        }),
        formatting.shellharden,
        formatting.black.with({
          extra_args = {
            "--fast",
          },
        }),
        formatting.stylua.with({
          extra_args = {
            "--config-path=stylua.toml",
          },
        }),
        diagnostics.flake8,
        diagnostics.selene,
        -- diagnostics.eslint_d.with({
        --   extra_args = {
        --     "--config=" .. dotfiles .. "/.eslintrc.js",
        --   },
        -- }),
        diagnostics.shellcheck.with({
          extra_filetypes = {
            "bash",
          },
          extra_args = {
            "--exclude=2139",
          },
        }),
      },
    }
  end,
  config = function(_, opts)
    require("null-ls").setup(opts)
  end,
}
