local rainbow_delimiters = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
  },
  priority = {
    [""] = 110,
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

local colorschemes = {
  everforest = { "Red", "Yellow", "Green", "Blue", "Orange", "Violet", "Cyan" },
  gruvbox = { "Violet", "Blue", "Cyan", "Green", "Yellow", "Orange", "Red" },
  sonokai = { "Yellow", "Violet", "Blue", "Orange", "Green", "Red", "Cyan" },
  monochrome = { "Red", "Yellow", "Orange" },
}

local function normalize_hl(name)
  if type(name) ~= "string" then return name end
  if name:match("^RainbowDelimiter") then return name end
  return "RainbowDelimiter" .. name
end

local function colorscheme_cb()
  local cs = vim.g.colors_name or ""
  local order = colorschemes[cs]
  if not order then return end

  local resolved = {}
  for i, item in ipairs(order) do
    resolved[i] = normalize_hl(item)
  end

  local config = vim.g.rainbow_delimiters or {}
  config.highlight = resolved
  vim.g.rainbow_delimiters = config
end

colorscheme_cb()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("rainbow_delimiters", { clear = true }),
  callback = colorscheme_cb,
})
