vim.g.colors_name = "everforest"

-- stylua: ignore start
local palette = {
  bg     = "#323d43",
  bg_alt = "#3c474d",
  fg     = "#d3c6aa",
  red    = "#e68183",
  orange = "#e39b7b",
  yellow = "#dbbc7f",
  green  = "#a7c080",
  aqua   = "#87c095",
  blue   = "#7fbbb3",
  purple = "#d39bb6",
  grey1  = "#868d80",
  grey2  = "#859289",
  grey3  = "#9da9a0",
}
-- stylua: ignore end

local highlights = {
  Normal = { fg = palette.fg, bg = palette.bg },
  NormalNC = { fg = palette.fg, bg = palette.bg },
  CursorLine = { bg = palette.bg_alt },
  CursorColumn = { bg = palette.bg_alt },
  LineNr = { fg = palette.grey2 },
  CursorLineNr = { fg = palette.yellow },
  VertSplit = { fg = palette.bg_alt },
  StatusLine = { fg = palette.fg, bg = palette.bg_alt },
  Pmenu = { fg = palette.fg, bg = palette.bg },
  PmenuSel = { fg = palette.bg, bg = palette.green },
  Visual = { bg = palette.grey1 },
  VisualNOS = { fg = palette.grey1 },
  Comment = { fg = palette.grey2, italic = true },
  Search = { fg = palette.bg, bg = palette.green },
  CurSearch = { fg = palette.bg, bg = palette.green },
  IncSearch = { fg = palette.bg, bg = palette.green },

  Constant = { fg = palette.aqua },
  String = { fg = palette.fg },
  Character = { fg = palette.green },
  Number = { fg = palette.purple },
  Boolean = { fg = palette.purple },
  Float = { fg = palette.purple },

  Identifier = { fg = palette.blue },
  Function = { fg = palette.green },

  Statement = { fg = palette.red },
  Conditional = { fg = palette.red },
  Repeat = { fg = palette.red },
  Label = { fg = palette.red },
  Operator = { fg = palette.orange },
  Keyword = { fg = palette.red },

  PreProc = { fg = palette.yellow },
  Include = { fg = palette.blue },
  Define = { fg = palette.red },
  Macro = { fg = palette.orange },
  PreCondit = { fg = palette.yellow },

  Type = { fg = palette.yellow },
  StorageClass = { fg = palette.yellow },
  Structure = { fg = palette.yellow },
  Typedef = { fg = palette.yellow },

  Special = { fg = palette.aqua },
  SpecialComment = { fg = palette.grey2, italic = true },
  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  Todo = { fg = palette.orange, bold = true, bg = palette.bg_alt },
  Error = { fg = palette.red, bg = palette.bg },

  Directory = { fg = palette.blue },

  ["@variable"] = { fg = palette.green },

  RainbowDelimiterRed = { fg = palette.red },
  RainbowDelimiterYellow = { fg = palette.yellow },
  RainbowDelimiterBlue = { fg = palette.blue },
  RainbowDelimiterOrange = { fg = palette.orange },
  RainbowDelimiterGreen = { fg = palette.green },
  RainbowDelimiterViolet = { fg = palette.purple },
  RainbowDelimiterCyan = { fg = palette.aqua },

  MiniIconsAzure = { fg = palette.blue },
  MiniIconsBlue = { fg = palette.blue },
  MiniIconsCyan = { fg = palette.aqua },
  MiniIconsGreen = { fg = palette.green },
  MiniIconsGrey = { fg = palette.grey1 },
  MiniIconsOrange = { fg = palette.orange },
  MiniIconsPurple = { fg = palette.purple },
  MiniIconsRed = { fg = palette.red },
  MiniIconsYellow = { fg = palette.yellow },

  MiniPickBorder = { fg = palette.fg },
  MiniPickBorderBusy = { fg = palette.fg },
  MiniPickBorderText = { fg = palette.red },
  MiniPickCursor = { fg = palette.fg },
  MiniPickIconDirectory = { fg = palette.blue },
  MiniPickIconFile = { fg = palette.yellow },
  MiniPickHeader = { fg = palette.blue },
  MiniPickMatchCurrent = { fg = palette.green, bg = palette.bg_alt },
  -- MiniPickMatchMarked = {},
  -- MiniPickMatchRanges = {},
  MiniPickNormal = { fg = palette.fg, bg = palette.bg },
  -- MiniPickPreviewLine = {},
  -- MiniPickPreviewRegion = {},
  MiniPickPrompt = { fg = palette.aqua },
  MiniPickPromptCaret = { fg = palette.red },
  MiniPickPromptPrefix = { fg = palette.red },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
