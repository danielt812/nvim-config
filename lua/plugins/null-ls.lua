local M = { "nvimtools/none-ls.nvim" }

M.enabled = true

M.dependencies = { "nvim-lua/plenary.nvim" }

M.event = { "BufReadPre" }

M.opts = function()
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
          "--tab-width=2",
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
      formatting.shfmt.with({
        filetypes = { "zsh", "bash", "sh" },
      }),
      formatting.stylua.with({
        extra_args = {
          "--config-path=stylua.toml",
        },
      }),
    },
  }
end

M.config = function(_, opts)
  require("null-ls").setup(opts)
end

return M
