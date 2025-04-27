vim.g.colors_name = "codedark"

-- stylua: ignore start
local palette = {
  bg     = "#262626",
  bg_alt = "#252526",
  fg     = "#d4d4d4",
  red    = "#d16969",
  orange = "#ce9178",
  yellow = "#dcdcaa",
  green  = "#608b4e",
  aqua   = "#4ec9b0",
  blue   = "#569cd6",
  purple = "#c586c0",
  grey1  = "#808080",
  grey2  = "#666666",
  grey3  = "#3c3c3c",
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
  Search = { fg = palette.bg_alt, bg = palette.fg, italic = true },

  Constant = { fg = palette.aqua },
  String = { fg = palette.orange },
  Character = { fg = palette.orange },
  Number = { fg = palette.aqua },
  Boolean = { fg = palette.aqua },
  Float = { fg = palette.aqua },

  Identifier = { fg = palette.blue },
  Function = { fg = palette.green },

  Statement = { fg = palette.purple },
  Conditional = { fg = palette.purple },
  Repeat = { fg = palette.purple },
  Label = { fg = palette.purple },
  Operator = { fg = palette.fg },
  Keyword = { fg = palette.purple },

  PreProc = { fg = palette.blue },
  Include = { fg = palette.blue },
  Define = { fg = palette.purple },
  Macro = { fg = palette.blue },
  PreCondit = { fg = palette.blue },

  Type = { fg = palette.blue },
  StorageClass = { fg = palette.blue },
  Structure = { fg = palette.blue },
  Typedef = { fg = palette.blue },

  Special = { fg = palette.aqua },
  SpecialComment = { fg = palette.grey2, italic = true },
  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  Todo = { fg = palette.yellow, bold = true, bg = palette.bg_alt },
  Error = { fg = palette.red, bg = palette.bg },

  Directory = { fg = palette.blue },

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
}

-- Apply highlights
for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
