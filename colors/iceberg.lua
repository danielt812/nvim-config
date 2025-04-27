vim.g.colors_name = "iceberg"

-- stylua: ignore start
local palette = {
  bg     = "#161821",
  bg_alt = "#1e2132",
  fg     = "#c6c8d1",
  red    = "#e27878",
  orange = "#e2a478",
  yellow = "#e2c778",
  green  = "#b4be82",
  aqua   = "#89b8c2",
  blue   = "#84a0c6",
  purple = "#a093c7",
  grey1  = "#444b6a",
  grey2  = "#5a6480",
  grey3  = "#818596",
}
-- stylua: ignore end

local highlights = {
  Normal = { fg = palette.fg, bg = palette.bg },
  NormalNC = { fg = palette.fg, bg = palette.bg },
  CursorLine = { bg = palette.bg_alt },
  CursorColumn = { bg = palette.bg_alt },
  LineNr = { fg = palette.grey1 },
  CursorLineNr = { fg = palette.yellow },
  VertSplit = { fg = palette.bg_alt },
  StatusLine = { fg = palette.fg, bg = palette.bg_alt },
  Pmenu = { fg = palette.fg, bg = palette.bg },
  PmenuSel = { fg = palette.bg, bg = palette.green },
  Visual = { bg = palette.grey1 },
  VisualNOS = { fg = palette.grey1 },
  Comment = { fg = palette.grey1, italic = true },
  Search = { fg = palette.bg_alt, bg = palette.fg, italic = true },

  Constant = { fg = palette.aqua },
  String = { fg = palette.green },
  Character = { fg = palette.green },
  Number = { fg = palette.purple },
  Boolean = { fg = palette.purple },
  Float = { fg = palette.purple },

  Identifier = { fg = palette.aqua },
  Function = { fg = palette.aqua },

  Statement = { fg = palette.red },
  Conditional = { fg = palette.red },
  Repeat = { fg = palette.red },
  Label = { fg = palette.red },
  Operator = { fg = palette.orange },
  Keyword = { fg = palette.red },

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

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
