local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  ensure_installed = { "lua", "vimdoc" },
  ignore_install = { "csv" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
})
