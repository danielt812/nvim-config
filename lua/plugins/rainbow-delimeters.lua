local rainbow_delimiters = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}

local color_schemes = {
  everforest = { "Red", "Yellow", "Green", "Blue", "Orange", "Violet", "Cyan" },
  gruvbox = { "Violet", "Blue", "Cyan", "Green", "Yellow", "Orange", "Red" },
  vscode = { "Yellow", "Violet", "Blue", "Orange", "Green", "Red", "Cyan" },
  panda = { "Yellow", "Violet", "Blue", "Orange", "Green", "Red", "Cyan" },
  sonokai = { "Yellow", "Violet", "Blue", "Orange", "Green", "Red", "Cyan" },
}

local function normalize_hl(name)
  if type(name) ~= "string" then return name end
  if name:match("^RainbowDelimiter") then return name end
  return "RainbowDelimiter" .. name
end

local function set_rainbow_order_for_current_colorscheme()
  local cs = vim.g.colors_name or ""
  local order = color_schemes[cs]
  if not order then return end

  local resolved = {}
  for i, item in ipairs(order) do
    resolved[i] = normalize_hl(item)
  end

  local config = vim.g.rainbow_delimiters or {}
  config.highlight = resolved
  vim.g.rainbow_delimiters = config
end

set_rainbow_order_for_current_colorscheme()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("rainbow_delimiters", { clear = true }),
  callback = set_rainbow_order_for_current_colorscheme,
})
