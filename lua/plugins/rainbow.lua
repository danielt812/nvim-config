local M = { "HiPhish/rainbow-delimiters.nvim" }

M.enabled = true

M.event = { "BufReadPre" }

M.opts = function()
  local rainbow_delimiters = require("rainbow-delimiters")

  return {
    strategy = {
      [""] = rainbow_delimiters.strategy["global"],
      vim = rainbow_delimiters.strategy["local"],
    },
    query = {
      [""] = "rainbow-delimiters",
      -- lua = "rainbow-blocks",
    },
    highlight = {
      "RainbowDelimiterYellow",
      "RainbowDelimiterViolet",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterRed",
      "RainbowDelimiterGreen",
      "RainbowDelimiterCyan",
    },
  }
end

M.config = function(_, opts)
  require("rainbow-delimiters.setup").setup(opts)
end

return M
