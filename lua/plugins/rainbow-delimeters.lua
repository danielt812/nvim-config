local rainbow = require("rainbow-delimiters.setup")
local rainbow_delimiters = require("rainbow-delimiters")

rainbow.setup({
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    -- lua = "rainbow-blocks",
  },
  highlight = {
    "RainbowDelimiterViolet",
    "RainbowDelimiterOrange",
    "RainbowDelimiterBlue",
    "RainbowDelimiterYellow",
    "RainbowDelimiterGreen",
    "RainbowDelimiterCyan",
    "RainbowDelimiterRed",
  },
})
