vim.g.colors_name = "dracula"

-- stylua: ignore start
local palette = {
  bg     = "#282a36",
  bg_alt = "#21222c",
  fg     = "#f8f8f2",
  red    = "#ff5555",
  orange = "#ffb86c",
  yellow = "#f1fa8c",
  green  = "#50fa7b",
  aqua   = "#8be9fd",
  blue   = "#6272a4",
  purple = "#bd93f9",
  grey1  = "#5f6a8e",
  grey2  = "#44475a",
  grey3  = "#343746",
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
  Pmenu = { fg = palette.fg, bg = palette.bg_alt },
  PmenuSel = { fg = palette.bg, bg = palette.blue },
  Visual = { bg = palette.grey1 },
  VisualNOS = { fg = palette.grey1 },
  Comment = { fg = palette.grey1, italic = true },
  Search = { fg = palette.bg_alt, bg = palette.fg, italic = true },

  Constant = { fg = palette.aqua },
  String = { fg = palette.yellow },
  Character = { fg = palette.green },
  Number = { fg = palette.purple },
  Boolean = { fg = palette.purple },
  Float = { fg = palette.purple },

  Identifier = { fg = palette.fg },
  Function = { fg = palette.green },

  Statement = { fg = palette.red },
  Conditional = { fg = palette.red },
  Repeat = { fg = palette.red },
  Label = { fg = palette.red },
  Operator = { fg = palette.orange },
  Keyword = { fg = palette.purple },

  PreProc = { fg = palette.orange },
  Include = { fg = palette.blue },
  Define = { fg = palette.red },
  Macro = { fg = palette.orange },
  PreCondit = { fg = palette.orange },

  Type = { fg = palette.yellow },
  StorageClass = { fg = palette.yellow },
  Structure = { fg = palette.yellow },
  Typedef = { fg = palette.yellow },

  Special = { fg = palette.aqua },
  SpecialComment = { fg = palette.grey1, italic = true },
  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  Todo = { fg = palette.orange, bold = true, bg = palette.bg_alt },
  Error = { fg = palette.red, bg = palette.bg },

  Directory = { fg = palette.purple },

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

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
