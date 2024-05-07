local M = { "nvim-treesitter/nvim-treesitter" }

M.enabled = true

M.event = { "BufReadPost", "BufNewFile" }

M.cmd = {
  "TSInstall",
  "TSUninstall",
  "TSUpdate",
  "TSUpdateSync",
  "TSInstallInfo",
  "TSInstallSync",
  "TSInstallFromGrammar",
}

M.config = function()
  local opts = {
    ensure_installed = require("parsers"),

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

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

  require("nvim-treesitter.configs").setup(opts)
end

return M

-- return {
--   "nvim-treesitter/nvim-treesitter",
--   enabled = true,
--   event = { "BufReadPost", "BufNewFile" },
--   dependencies = {
--     { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
--   },
--   cmd = {
--     "TSInstall",
--     "TSUninstall",
--     "TSUpdate",
--     "TSUpdateSync",
--     "TSInstallInfo",
--     "TSInstallSync",
--     "TSInstallFromGrammar",
--   },
--   opts = function()
--     return {
--       ensure_installed = require("parsers"),
--
--       -- Install parsers synchronously (only applied to `ensure_installed`)
--       sync_install = false,
--
--       -- Automatically install missing parsers when entering buffer
--       auto_install = true,
--
--       -- List of parsers to ignore installing (for "all")
--       ignore_install = { "csv" },
--
--       highlight = {
--         enable = true,
--         additional_vim_regex_highlighting = false,
--       },
--       indent = {
--         enable = false,
--       },
--     }
--   end,
--   config = function(_, opts)
--     require("nvim-treesitter.configs").setup(opts)
--   end,
-- }
