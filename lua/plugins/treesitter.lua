local M = { "nvim-treesitter/nvim-treesitter" }

M.enabled = true

M.event = { "BufRead", "BufNewFile" }

M.cmd = {
  "TSInstall",
  "TSUninstall",
  "TSUpdate",
  "TSUpdateSync",
  "TSInstallInfo",
  "TSInstallSync",
  "TSInstallFromGrammar",
}

M.opts = function()
  return {
    ensure_installed = require("parsers"),

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "csv" },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = false,
    },
  }
end

M.config = function(_, opts)
  require("nvim-treesitter.configs").setup(opts)
end

return M
