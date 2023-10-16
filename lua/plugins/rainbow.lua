return {
  "hiphish/rainbow-delimiters.nvim",
  event = { "BufReadPre" },
  opts = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    return {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      highlight = {
        -- "RainbowDelimiterRed",
        -- "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
  config = function(_, opts)
    require("rainbow-delimiters.setup").setup(opts)
  end,
}
