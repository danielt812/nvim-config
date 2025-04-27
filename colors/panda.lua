vim.g.colors_name = "panda"

-- stylua: ignore start
local palette = {
  bg     = "#373b41",
  bg_alt = "#454647",
  fg     = "#ffffff",
  red    = "#ff2c6d",
  orange = "#ffcc95",
  yellow = "#ff9ac1",
  green  = "#19f9d8",
  aqua   = "#6fe7d2",
  blue   = "#6fc1ff",
  purple = "#b084eb",
  grey1  = "#757575",
  grey2  = "#cdcdcd",
  grey3  = "#e6e6e6",
}
-- stylua: ignore end

local highlights = {
  Normal = { fg = palette.fg, bg = palette.bg },
  NormalNC = { fg = palette.fg, bg = palette.bg },
  CursorLine = { bg = palette.bg_alt },
  CursorColumn = { bg = palette.bg_alt },
  LineNr = { fg = palette.grey1 },
  CursorLineNr = { fg = palette.orange },
  VertSplit = { fg = palette.bg_alt },
  StatusLine = { fg = palette.fg, bg = palette.bg_alt },
  Pmenu = { fg = palette.fg, bg = palette.bg_alt },
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

  Identifier = { fg = palette.blue },
  Function = { fg = palette.blue },

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

  Directory = { fg = palette.blue, bg = palette.bg },

  RainbowDelimiterRed = { fg = palette.red },
  RainbowDelimiterYellow = { fg = palette.yellow },
  RainbowDelimiterBlue = { fg = palette.blue },
  RainbowDelimiterOrange = { fg = palette.orange },
  RainbowDelimiterGreen = { fg = palette.green },
  RainbowDelimiterViolet = { fg = palette.purple },
  RainbowDelimiterCyan = { fg = palette.aqua },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
