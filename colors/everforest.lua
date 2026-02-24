vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end

vim.g.colors_name = "everforest"

-- stylua: ignore
local dark = {
  bg_dim    = "#232a2e",
  bg0       = "#2d353b",
  bg1       = "#343f44",
  bg2       = "#3d484d",
  bg3       = "#475258",
  bg4       = "#4f585e",
  bg5       = "#56635f",

  bg_red    = "#4c3432",
  bg_orange = "#4a3a2f",
  bg_yellow = "#4f422e",
  bg_green  = "#3b4439",
  bg_aqua   = "#364544",
  bg_blue   = "#374141",
  bg_purple = "#443840",

  grey0     = "#7a8478",
  grey1     = "#859289",
  grey2     = "#9da9a0",

  fg        = "#d3c6aa",
  white     = "#ffffff",
  red       = "#e67e80",
  orange    = "#e69875",
  yellow    = "#dbbc7f",
  green     = "#a7c080",
  aqua      = "#83c092",
  blue      = "#7fbbb3",
  purple    = "#d699b6",
}

-- stylua: ignore
local light = {
  bg_dim    = "#efebd4",
  bg0       = "#fdf6e3",
  bg1       = "#f4f0d9",
  bg2       = "#efebd4",
  bg3       = "#e6e2cc",
  bg4       = "#e0dcc7",
  bg5       = "#bdc3af",

  bg_red    = "#f9d8d6",
  bg_orange = "#f9e2d6",
  bg_yellow = "#f9e0b0",
  bg_green  = "#dde5c2",
  bg_aqua   = "#d0e3d7",
  bg_blue   = "#cdd8d8",
  bg_purple = "#ead9e3",

  grey0     = "#a6b0a0",
  grey1     = "#939f91",
  grey2     = "#829181",

  fg        = "#5c6a72",
  white     = "#000000",
  red       = "#f85552",
  orange    = "#f57d26",
  yellow    = "#dfa000",
  green     = "#8da101",
  aqua      = "#35a77c",
  blue      = "#3a94c5",
  purple    = "#df69ba",
}

local palette = vim.o.background == "light" and light or dark

local highlights = {
  -- INFO: Common Highlight Groups
  -- stylua: ignore start
  Normal   = { fg = palette.fg,    bg = palette.bg0 },
  NormalNC = { fg = palette.fg,    bg = palette.bg0 },
  Terminal = { fg = palette.white, bg = palette.bg0 },
  -- stylua: ignore end

  -- stylua: ignore start
  EndOfBuffer = {},
  Folded      = { fg = palette.grey1, bg = palette.bg2 },
  -- stylua: ignore end

  -- stylua: ignore start
  FoldColumn = { fg = palette.bg5 },
  SignColumn = { fg = palette.fg },
  -- stylua: ignore end

  -- stylua: ignore start
  Search    = { fg = palette.bg0, bg = palette.green },
  IncSearch = { fg = palette.bg0, bg = palette.red },
  CurSearch = { fg = palette.bg0, bg = palette.red },
  -- stylua: ignore end

  -- stylua: ignore start
  Substitute = { fg = palette.bg0, bg = palette.green },
  -- stylua: ignore end

  -- stylua: ignore start
  ColorColumn  = { bg = palette.bg3 },
  CursorColumn = { bg = palette.bg3 },
  -- stylua: ignore end

  -- stylua: ignore start
  Cursor     = {},
  lCursor    = {},
  CursorIM   = {},
  TermCursor = {},
  -- stylua: ignore end

  -- stylua: ignore start
  CursorLineNr    = { fg = palette.fg },
  CursorLine      = { bg = palette.bg3 },
  CursorLineFloat = { bg = palette.bg4 },
  -- stylua: ignore end

  -- stylua: ignore start
  LineNr      = { fg = palette.grey0 },
  LineNrAbove = { fg = palette.grey0 },
  LineNrBelow = { fg = palette.grey0 },
  -- stylua: ignore end

  -- stylua: ignore start
  ToolbarLine   = { fg = palette.fg, bg  = palette.bg2 },
  ToolbarButton = { fg = palette.bg0, bg = palette.grey2 },
  -- stylua: ignore end

  -- stylua: ignore start
  DiffText   = { fg = palette.bg0, bg = palette.blue },
  DiffAdd    = { bg = palette.bg_green },
  DiffChange = { bg = palette.bg_blue },
  DiffDelete = { bg = palette.bg_red },
  -- stylua: ignore end

  -- stylua: ignore start
  Directory = { fg = palette.green },
  -- stylua: ignore end

  -- stylua: ignore start
  ErrorMsg = { fg = palette.red, bold = true, underline = true },
  -- stylua: ignore end

  -- stylua: ignore start
  WarningMsg = { fg = palette.yellow, bold = true },
  ModeMsg    = { fg = palette.fg,     bold = true },
  MoreMsg    = { fg = palette.yellow, bold = true },
  -- stylua: ignore end

  -- stylua: ignore start
  MatchParen = { bg = palette.bg4 },
  NonText    = { fg = palette.bg5 },
  Whitespace = { fg = palette.bg4 },
  SpecialKey = { fg = palette.orange },
  -- stylua: ignore end

  -- stylua: ignore start
  Conceal = { fg = palette.grey0 },
  -- stylua: ignore end

  -- stylua: ignore start
  Pmenu        = { fg = palette.fg,    bg = palette.bg3 },
  PmenuSel     = { fg = palette.bg3,   bg = palette.grey2 },
  PmenuKind    = { fg = palette.fg,    bg = palette.bg3 },
  PmenuKindSel = { fg = palette.bg3,   bg = palette.grey2 },
  PmenuExtra   = { fg = palette.grey2, bg = palette.bg3 },
  PmenuSbar    = { bg = palette.bg3 },
  PmenuThumb   = { bg = palette.grey0 },
  WildMenu     = { fg = palette.bg3,   bg = palette.grey2 },
  -- stylua: ignore end

  -- stylua: ignore start
  NormalFloat       = { fg = palette.fg,    bg = palette.bg2 },
  FloatBorder       = { fg = palette.grey1, bg = palette.bg2 },
  FloatTitle        = { fg = palette.grey1, bg = palette.bg2 },
  FloatTitleFocused = { fg = palette.green, bg = palette.bg2 }, -- NOTE: Custom
  -- stylua: ignore end

  -- stylua: ignore start
  SpellBad   = { undercurl = true, sp = palette.red },
  SpellCap   = { undercurl = true, sp = palette.blue },
  SpellLocal = { undercurl = true, sp = palette.aqua },
  SpellRare  = { undercurl = true, sp = palette.purple },
  -- stylua: ignore end

  -- stylua: ignore start
  WinBar       = { fg = palette.fg },
  WinBarNC     = { fg = palette.grey1 },
  VertSplit    = { fg = palette.bg5 },
  WinSeparator = { fg = palette.bg5 },
  -- stylua: ignore end

  -- stylua: ignore start
  Visual    = { bg = palette.bg3 },
  VisualNOS = { bg = palette.bg3 },
  -- stylua: ignore end

  -- stylua: ignore start
  QuickFixLine = { fg = palette.purple },
  -- stylua: ignore end

  -- stylua: ignore start
  TabLine     = { fg = palette.grey1, bg = palette.bg1 },
  TabLineFill = { fg = palette.bg2,   bg = palette.bg1 },
  TabLineSel  = { fg = palette.blue,  bg = palette.bg1 },
  -- stylua: ignore end

  -- stylua: ignore start
  StatusLine       = { fg = palette.grey1, bg = palette.bg2 },
  StatusLineTerm   = { fg = palette.grey1, bg = palette.bg2 },
  StatusLineNC     = { fg = palette.grey1, bg = palette.bg1 },
  StatusLineTermNC = { fg = palette.grey1, bg = palette.bg1 },
  -- stylua: ignore end

  -- stylua: ignore start
  Debug           = { fg = palette.orange },
  debugPC         = { fg = palette.bg0, bg = palette.green },
  debugBreakpoint = { fg = palette.bg0, bg = palette.red },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticError = { fg = palette.red },
  DiagnosticHint  = { fg = palette.green },
  DiagnosticInfo  = { fg = palette.blue },
  DiagnosticOk    = { fg = palette.purple },
  DiagnosticWarn  = { fg = palette.yellow },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticUnderlineError = { undercurl = true, sp = palette.red },
  DiagnosticUnderlineHint  = { undercurl = true, sp = palette.green },
  DiagnosticUnderlineInfo  = { undercurl = true, sp = palette.blue },
  DiagnosticUnderlineOk    = { undercurl = true, sp = palette.purple },
  DiagnosticUnderlineWarn  = { undercurl = true, sp = palette.yellow },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticFloatingError = { link = "ErrorFloat" },
  DiagnosticFloatingHint  = { link = "HintFloat" },
  DiagnosticFloatingInfo  = { link = "InfoFloat" },
  DiagnosticFloatingOk    = { link = "OkFloat" },
  DiagnosticFloatingWarn  = { link = "WarningFloat" },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticVirtualTextError = { link = "VirtualTextError" },
  DiagnosticVirtualTextHint  = { link = "VirtualTextHint" },
  DiagnosticVirtualTextInfo  = { link = "VirtualTextInfo" },
  DiagnosticVirtualTextOk    = { link = "VirtualTextOk" },
  DiagnosticVirtualTextWarn  = { link = "VirtualTextWarning" },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticSignError = { link = "Red" },
  DiagnosticSignHint  = { link = "Green" },
  DiagnosticSignInfo  = { link = "Blue" },
  DiagnosticSignOk    = { link = "Purple" },
  DiagnosticSignWarn  = { link = "Yellow" },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticUnnecessary = { fg   = palette.grey1 },
  DiagnosticDeprecated  = { link = "Strikethrough" },
  -- stylua: ignore end

  -- stylua: ignore start
  InlayHints   = { fg   = palette.grey0, bg = palette.bg0 },
  LspInlayHint = { link = "InlayHints" },
  -- stylua: ignore end

  -- stylua: ignore start
  CurrentWord       = { link = "Underline" },
  LspReferenceText  = { link = "CurrentWord" },
  LspReferenceRead  = { link = "CurrentWord" },
  LspReferenceWrite = { link = "CurrentWord" },
  -- stylua: ignore end

  -- stylua: ignore start
  LspCodeLens          = { link = "VirtualTextInfo" },
  LspCodeLensSeparator = { link = "VirtualTextHint" },
  -- stylua: ignore end

  -- stylua: ignore start
  LspSignatureActiveParameter = { link = "Search" },
  -- stylua: ignore end

  -- stylua: ignore start
  healthError   = { link = "Red" },
  healthSuccess = { link = "Green" },
  healthWarning = { link = "Yellow" },
  -- stylua: ignore end

  -- INFO: Syntax Highlight Groups
  -- stylua: ignore start
  Boolean      = { link = "Purple" },
  Define       = { link = "Purple" },
  Float        = { link = "Purple" },
  Include      = { link = "Purple" },
  Number       = { link = "Purple" },
  PreCondit    = { link = "Purple" },
  PreProc      = { link = "Purple" },
  Conditional  = { link = "Red" },
  Error        = { link = "Red" },
  Exception    = { link = "Red" },
  Keyword      = { link = "Red" },
  Repeat       = { link = "Red" },
  Statement    = { link = "Red" },
  Typedef      = { link = "Red" },
  Label        = { link = "Orange" },
  Operator     = { link = "Orange" },
  StorageClass = { link = "Orange" },
  Structure    = { link = "Orange" },
  Tag          = { link = "Orange" },
  Title        = { link = "Orange" },
  Special      = { link = "Yellow" },
  SpecialChar  = { link = "Yellow" },
  Type         = { link = "Yellow" },
  Character    = { link = "Green" },
  Function     = { link = "Green" },
  Constant     = { link = "Aqua" },
  Macro        = { link = "Aqua" },
  String       = { link = "Aqua" },
  Identifier   = { link = "Blue"},
  Todo         = {},
  -- stylua: ignore end

  -- stylua: ignore start
  Comment        = { fg = palette.grey1, italic = true },
  SpecialComment = { fg = palette.grey1, italic = true },
  -- stylua: ignore end

  -- stylua: ignore start
  Delimiter = { fg = palette.fg },
  Ignore    = { fg = palette.grey1 },
  -- stylua: ignore end

  -- INFO: Predefined Highlight Groups
  -- stylua: ignore start
  Fg     = { fg = palette.fg },
  Grey   = { fg = palette.grey1 },
  White  = { fg = palette.white },
  Red    = { fg = palette.red },
  Orange = { fg = palette.orange },
  Yellow = { fg = palette.yellow },
  Green  = { fg = palette.green },
  Aqua   = { fg = palette.aqua },
  Blue   = { fg = palette.blue },
  Purple = { fg = palette.purple },
  -- stylua: ignore end

  -- stylua: ignore start
  FgItalic     = { fg = palette.fg,     italic = true },
  GreyItalic   = { fg = palette.grey1,  italic = true },
  WhiteItalic  = { fg = palette.white,  italic = true },
  RedItalic    = { fg = palette.red,    italic = true },
  OrangeItalic = { fg = palette.orange, italic = true },
  YellowItalic = { fg = palette.yellow, italic = true },
  GreenItalic  = { fg = palette.green,  italic = true },
  AquaItalic   = { fg = palette.aqua,   italic = true },
  BlueItalic   = { fg = palette.blue,   italic = true },
  PurpleItalic = { fg = palette.purple, italic = true },
  -- stylua: ignore end

  -- stylua: ignore start
  Bold          = { bold          = true },
  Italic        = { italic        = true },
  Underline     = { underline     = true },
  Strikethrough = { strikethrough = true },
  -- stylua: ignore end

  -- stylua: ignore start
  BgRed    = { bg = palette.bg_red },
  BgOrange = { bg = palette.bg_orange },
  BgYellow = { bg = palette.bg_yellow },
  BgGreen  = { bg = palette.bg_green },
  BgAqua   = { bg = palette.bg_aqua },
  BgBlue   = { bg = palette.bg_blue },
  BgPurple = { bg = palette.bg_purple },
  -- stylua: ignore end

  -- stylua: ignore start
  Added   = { link = "Green" },
  Removed = { link = "Red" },
  Changed = { link = "Blue" },
  -- stylua: ignore end

  -- stylua: ignore start
  ErrorText   = { bg = palette.bg_red, undercurl    = true },
  HintText    = { bg = palette.bg_purple, undercurl = true },
  InfoText    = { bg = palette.bg_blue, undercurl   = true },
  WarningText = { bg = palette.bg_yellow, undercurl = true },
  -- stylua: ignore end

  -- stylua: ignore start
  VirtualTextError   = { link = "Red" },
  VirtualTextHint    = { link = "Purple" },
  VirtualTextInfo    = { link = "Blue" },
  VirtualTextOk      = { link = "Green" },
  VirtualTextWarning = { link = "Yellow" },
  -- stylua: ignore end

  -- stylua: ignore start
  ErrorFloat   = { fg = palette.red,    bg = palette.bg2 },
  WarningFloat = { fg = palette.yellow, bg = palette.bg2 },
  InfoFloat    = { fg = palette.blue,   bg = palette.bg2 },
  HintFloat    = { fg = palette.green,  bg = palette.bg2 },
  OkFloat      = { fg = palette.purple, bg = palette.bg2 },
  -- stylua: ignore end

  -- INFO: Treesitter Highlight Groups
  -- stylua: ignore start
  TSStrong    = { link = "Bold" },
  TSEmphasis  = { link = "Italic" },
  TSUnderline = { link = "Underline" },
  TSStrike    = { link = "Strikethrough" },
  -- stylua: ignore end

  -- stylua: ignore start
  TSNote    = {},
  TSWarning = {},
  TSDanger  = {},
  TSTodo    = {},
  TSURI     = { fg = palette.blue, underline = true },
  -- stylua: ignore end

  -- stylua: ignore start
  TSAnnotation           = { link = "Purple" },
  TSAttribute            = { link = "Purple" },
  TSBoolean              = { link = "Purple" },
  TSCharacter            = { link = "Aqua" },
  TSCharacterSpecial     = { link = "SpecialChar" },
  TSComment              = { link = "Comment" },
  TSConditional          = { link = "Red" },
  TSConstBuiltin         = { link = "Purple" },
  TSConstMacro           = { link = "Purple" },
  TSConstant             = { link = "Constant" },
  TSConstructor          = { link = "Green" },
  TSDebug                = { link = "Debug" },
  TSDefine               = { link = "Define" },
  TSEnvironment          = { link = "Macro" },
  TSEnvironmentName      = { link = "Type" },
  TSError                = { link = "Error" },
  TSException            = { link = "Red" },
  TSField                = { link = "Blue" },
  TSFloat                = { link = "Purple" },
  TSFuncBuiltin          = { link = "Green" },
  TSFuncMacro            = { link = "Green" },
  TSFunction             = { link = "Green" },
  TSFunctionCall         = { link = "Green" },
  TSInclude              = { link = "Red" },
  TSKeyword              = { link = "Red" },
  TSKeywordFunction      = { link = "Red" },
  TSKeywordOperator      = { link = "Orange" },
  TSKeywordReturn        = { link = "Red" },
  TSLabel                = { link = "Orange" },
  TSLiteral              = { link = "String" },
  TSMath                 = { link = "Blue" },
  TSMethod               = { link = "Green" },
  TSMethodCall           = { link = "Green" },
  TSModuleInfoGood       = { link = "Green" },
  TSModuleInfoBad        = { link = "Red" },
  TSNamespace            = { link = "Yellow" },
  TSNone                 = { link = "Fg" },
  TSNumber               = { link = "Purple" },
  TSOperator             = { link = "Orange" },
  TSParameter            = { link = "Fg" },
  TSParameterReference   = { link = "Fg" },
  TSPreProc              = { link = "PreProc" },
  TSProperty             = { link = "Blue" },
  TSPunctBracket         = { link = "Fg" },
  TSPunctDelimiter       = { link = "Grey" },
  TSPunctSpecial         = { link = "Blue" },
  TSRepeat               = { link = "Red" },
  TSStorageClass         = { link = "Orange" },
  TSStorageClassLifetime = { link = "Orange" },
  TSString               = { link = "Aqua" },
  TSStringEscape         = { link = "Green" },
  TSStringRegex          = { link = "Green" },
  TSStringSpecial        = { link = "SpecialChar" },
  TSSymbol               = { link = "Fg" },
  TSTag                  = { link = "Orange" },
  TSTagAttribute         = { link = "Green" },
  TSTagDelimiter         = { link = "Green" },
  TSText                 = { link = "Green" },
  TSTextReference        = { link = "Constant" },
  TSTitle                = { link = "Title" },
  TSType                 = { link = "Yellow" },
  TSTypeBuiltin          = { link = "Yellow" },
  TSTypeDefinition       = { link = "Yellow" },
  TSTypeQualifier        = { link = "Orange" },
  TSVariable             = { link = "Fg" },
  TSVariableBuiltin      = { link = "Purple" },
  -- stylua: ignore end

  -- stylua: ignore start
  ["@annotation"]               = { link = "TSAnnotation" },
  ["@attribute"]                = { link = "TSAttribute" },
  ["@boolean"]                  = { link = "TSBoolean" },
  ["@character"]                = { link = "TSCharacter" },
  ["@character.special"]        = { link = "TSCharacterSpecial" },
  ["@comment"]                  = { link = "TSComment" },
  ["@comment.error"]            = { link = "TSDanger" },
  ["@comment.note"]             = { link = "TSNote" },
  ["@comment.todo"]             = { link = "TSTodo" },
  ["@comment.warning"]          = { link = "TSWarning" },
  ["@conceal"]                  = { link = "Grey" },
  ["@conditional"]              = { link = "TSConditional" },
  ["@constant"]                 = { link = "TSConstant" },
  ["@constant.builtin"]         = { link = "TSConstBuiltin" },
  ["@constant.macro"]           = { link = "TSConstMacro" },
  ["@constant.regex"]           = { link = "TSConstBuiltin" },
  ["@constructor"]              = { link = "TSConstructor" },
  ["@debug"]                    = { link = "TSDebug" },
  ["@define"]                   = { link = "TSDefine" },
  ["@diff.delta"]               = { link = "Changed" },
  ["@diff.minus"]               = { link = "Removed" },
  ["@diff.plus"]                = { link = "Green" },
  ["@error"]                    = { link = "TSError" }, -- This has been removed from nvim-treesitter
  ["@exception"]                = { link = "TSException" },
  ["@field"]                    = { link = "TSField" },
  ["@float"]                    = { link = "TSFloat" },
  ["@function"]                 = { link = "TSFunction" },
  ["@function.builtin"]         = { link = "TSFuncBuiltin" },
  ["@function.call"]            = { link = "TSFunctionCall" },
  ["@function.macro"]           = { link = "TSFuncMacro" },
  ["@function.method"]          = { link = "TSMethod" },
  ["@function.method.call"]     = { link = "TSMethodCall" },
  ["@include"]                  = { link = "TSInclude" },
  ["@keyword"]                  = { link = "TSKeyword" },
  ["@keyword.conditional"]      = { link = "TSConditional" },
  ["@keyword.debug"]            = { link = "TSDebug" },
  ["@keyword.directive"]        = { link = "TSPreProc" },
  ["@keyword.directive.define"] = { link = "TSDefine" },
  ["@keyword.exception"]        = { link = "TSException" },
  ["@keyword.function"]         = { link = "TSKeywordFunction" },
  ["@keyword.import"]           = { link = "TSInclude" },
  ["@keyword.modifier"]         = { link = "TSTypeQualifier" },
  ["@keyword.operator"]         = { link = "TSKeywordOperator" },
  ["@keyword.repeat"]           = { link = "TSRepeat" },
  ["@keyword.return"]           = { link = "TSKeywordReturn" },
  ["@keyword.storage"]          = { link = "TSStorageClass" },
  ["@label"]                    = { link = "TSLabel" },
  ["@markup.emphasis"]          = { link = "TSEmphasis" },
  ["@markup.environment"]       = { link = "TSEnvironment" },
  ["@markup.environment.name"]  = { link = "TSEnvironmentName" },
  ["@markup.heading"]           = { link = "TSTitle" },
  ["@markup.link"]              = { link = "TSTextReference" },
  ["@markup.link.label"]        = { link = "TSStringSpecial" },
  ["@markup.link.url"]          = { link = "TSURI" },
  ["@markup.list"]              = { link = "TSPunctSpecial" },
  ["@markup.list.checked"]      = { link = "Green" },
  ["@markup.list.unchecked"]    = { link = "Ignore" },
  ["@markup.math"]              = { link = "TSMath" },
  ["@markup.note"]              = { link = "TSNote" },
  ["@markup.quote"]             = { link = "Grey" },
  ["@markup.raw"]               = { link = "TSLiteral" },
  ["@markup.strike"]            = { link = "TSStrike" },
  ["@markup.strong"]            = { link = "TSStrong" },
  ["@markup.underline"]         = { link = "TSUnderline" },
  ["@markup.italic"]            = { link = "TSEmphasis" }, -- NOTE: nvim-0.8
  ["@math"]                     = { link = "TSMath" },
  ["@method"]                   = { link = "TSMethod" },
  ["@method.call"]              = { link = "TSMethodCall" },
  ["@module"]                   = { link = "TSNamespace" },
  ["@namespace"]                = { link = "TSNamespace" },
  ["@none"]                     = { link = "TSNone" },
  ["@number"]                   = { link = "TSNumber" },
  ["@number.float"]             = { link = "TSFloat" },
  ["@operator"]                 = { link = "TSOperator" },
  ["@parameter"]                = { link = "TSParameter" },
  ["@parameter.reference"]      = { link = "TSParameterReference" },
  ["@preproc"]                  = { link = "TSPreProc" },
  ["@property"]                 = { link = "TSProperty" },
  ["@punctuation.bracket"]      = { link = "TSPunctBracket" },
  ["@punctuation.delimiter"]    = { link = "TSPunctDelimiter" },
  ["@punctuation.special"]      = { link = "TSPunctSpecial" },
  ["@repeat"]                   = { link = "TSRepeat" },
  ["@storageclass"]             = { link = "TSStorageClass" },
  ["@storageclass.lifetime"]    = { link = "TSStorageClassLifetime" },
  ["@strike"]                   = { link = "TSStrike" },
  ["@string"]                   = { link = "TSString" },
  ["@string.escape"]            = { link = "TSStringEscape" },
  ["@string.regex"]             = { link = "TSStringRegex" },
  ["@string.regexp"]            = { link = "TSStringRegex" },
  ["@string.special"]           = { link = "TSStringSpecial" },
  ["@string.special.symbol"]    = { link = "TSSymbol" },
  ["@string.special.url"]       = { link = "TSURI" },
  ["@symbol"]                   = { link = "TSSymbol" },
  ["@tag"]                      = { link = "TSTag" },
  ["@tag.attribute"]            = { link = "TSTagAttribute" },
  ["@tag.delimiter"]            = { link = "TSTagDelimiter" },
  ["@text"]                     = { link = "TSText" },
  ["@text.danger"]              = { link = "TSDanger" },
  ["@text.diff.add"]            = { link = "Green" },
  ["@text.diff.delete"]         = { link = "Removed" },
  ["@text.emphasis"]            = { link = "TSEmphasis" },
  ["@text.environment"]         = { link = "TSEnvironment" },
  ["@text.environment.name"]    = { link = "TSEnvironmentName" },
  ["@text.literal"]             = { link = "TSLiteral" },
  ["@text.gitcommit"]           = { link = "TSNone" },
  ["@text.math"]                = { link = "TSMath" },
  ["@text.note"]                = { link = "TSNote" },
  ["@text.reference"]           = { link = "TSTextReference" },
  ["@text.strike"]              = { link = "TSStrike" },
  ["@text.strong"]              = { link = "TSStrong" },
  ["@text.title"]               = { link = "TSTitle" },
  ["@text.todo"]                = { link = "TSTodo" },
  ["@text.todo.checked"]        = { link = "Green" },
  ["@text.todo.unchecked"]      = { link = "Ignore" },
  ["@text.underline"]           = { link = "TSUnderline" },
  ["@text.uri"]                 = { link = "TSURI" },
  ["@text.warning"]             = { link = "TSWarning" },
  ["@todo"]                     = { link = "TSTodo" },
  ["@type"]                     = { link = "TSType" },
  ["@type.builtin"]             = { link = "TSTypeBuiltin" },
  ["@type.definition"]          = { link = "TSTypeDefinition" },
  ["@type.qualifier"]           = { link = "TSTypeQualifier" },
  ["@uri"]                      = { link = "TSURI" },
  ["@variable"]                 = { link = "TSVariable" },
  ["@variable.builtin"]         = { link = "TSVariableBuiltin" },
  ["@variable.member"]          = { link = "TSField" },
  ["@variable.parameter"]       = { link = "TSParameter" },
  -- stylua: ignore end

  -- INFO: LSP Highlight Groups
  -- stylua: ignore start
  ["@lsp.type.class"]         = { link = "TSType" },
  ["@lsp.type.comment"]       = { link = "TSComment" },
  ["@lsp.type.decorator"]     = { link = "TSFunction" },
  ["@lsp.type.enum"]          = { link = "TSType" },
  ["@lsp.type.enumMember"]    = { link = "TSProperty" },
  ["@lsp.type.function"]      = { link = "TSFunction" },
  ["@lsp.type.interface"]     = { link = "TSType" },
  ["@lsp.type.keyword"]       = { link = "TSKeyword" },
  ["@lsp.type.macro"]         = { link = "TSConstMacro" },
  ["@lsp.type.method"]        = { link = "TSMethod" },
  ["@lsp.type.modifier"]      = { link = "TSTypeQualifier" },
  ["@lsp.type.namespace"]     = { link = "TSNamespace" },
  ["@lsp.type.number"]        = { link = "TSNumber" },
  ["@lsp.type.operator"]      = { link = "TSOperator" },
  ["@lsp.type.parameter"]     = { link = "TSParameter" },
  ["@lsp.type.property"]      = { link = "TSProperty" },
  ["@lsp.type.regexp"]        = { link = "TSStringRegex" },
  ["@lsp.type.string"]        = { link = "TSString" },
  ["@lsp.type.struct"]        = { link = "TSType" },
  ["@lsp.type.type"]          = { link = "TSType" },
  ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
  ["@lsp.type.variable"]      = { link = "TSVariable" },
  -- stylua: ignore end

  -- INFO: Plugin Highlight Groups

  -- https://github.com/HiPhish/rainbow-delimiters.nvim
  -- stylua: ignore start
  RainbowDelimiterRed    = { link = "Red" },
  RainbowDelimiterOrange = { link = "Orange" },
  RainbowDelimiterYellow = { link = "Yellow" },
  RainbowDelimiterGreen  = { link = "Green" },
  RainbowDelimiterCyan   = { link = "Aqua" },
  RainbowDelimiterBlue   = { link = "Blue" },
  RainbowDelimiterViolet = { link = "Purple" },
  -- stylua: ignore end

  -- https://github.com/SmiteshP/nvim-navic
  -- stylua: ignore start
  NavicIconsFile          = { link = "Fg" },
  NavicIconsModule        = { link = "Yellow" },
  NavicIconsNamespace     = { link = "Fg" },
  NavicIconsPackage       = { link = "Fg" },
  NavicIconsClass         = { link = "Orange" },
  NavicIconsMethod        = { link = "Blue" },
  NavicIconsProperty      = { link = "Green" },
  NavicIconsField         = { link = "Green" },
  NavicIconsConstructor   = { link = "Orange" },
  NavicIconsEnum          = { link = "Orange" },
  NavicIconsInterface     = { link = "Orange" },
  NavicIconsFunction      = { link = "Blue" },
  NavicIconsVariable      = { link = "Purple" },
  NavicIconsConstant      = { link = "Purple" },
  NavicIconsString        = { link = "Green" },
  NavicIconsNumber        = { link = "Orange" },
  NavicIconsBoolean       = { link = "Orange" },
  NavicIconsArray         = { link = "Orange" },
  NavicIconsObject        = { link = "Orange" },
  NavicIconsKey           = { link = "Purple" },
  NavicIconsKeyword       = { link = "Purple" },
  NavicIconsNull          = { link = "Orange" },
  NavicIconsEnumMember    = { link = "Green" },
  NavicIconsStruct        = { link = "Orange" },
  NavicIconsEvent         = { link = "Orange" },
  NavicIconsOperator      = { link = "Fg" },
  NavicIconsTypeParameter = { link = "Green" },
  NavicText               = { link = "Fg" },
  NavicSeparator          = { link = "Grey" },
  -- stylua: ignore end

  -- https://github.com/nvim-mini/mini.nvim
  -- stylua: ignore start
  MiniAnimateCursor      = { reverse = true, nocombine = true },
  MiniAnimateNormalFloat = { link    = "NormalFloat" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniClueBorder              = { link = "FloatBorder" },
  MiniClueDescGroup           = { link = "DiagnosticFloatingWarn" },
  MiniClueDescSingle          = { link = "NormalFloat" },
  MiniClueNextKey             = { link = "DiagnosticFloatingHint" },
  MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
  MiniClueSeparator           = { link = "DiagnosticFloatingInfo" },
  MiniClueTitle               = { link = "FloatTitle" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCmdlinePeekBorder = { link = "FloatBorder" },
  MiniCmdlinePeekLineNr = { link = "DiagnosticSignWarn" },
  MiniCmdlinePeekNormal = { link = "NormalFloat" },
  MiniCmdlinePeekSep    = { link = "SignColumn" },
  MiniCmdlinePeekSign   = { link = "DiagnosticSignHint" },
  MiniCmdlinePeekTitle  = { link = "FloatTitle" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCompletionActiveParameter    = { link = "LspSignatureActiveParameter" },
  MiniCompletionDeprecated         = { link = "DiagnosticDeprecated" },
  MiniCompletionInfoBorderOutdated = { link = "DiagnosticFloatingWarn" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCursorword        = { link = "Underline" },
  MiniCursorwordCurrent = { link = "Underline" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniDepsChangeAdded   = { link = "Added" },
  MiniDepsChangeRemoved = { link = "Removed" },
  MiniDepsHints         = { link = "DiagnosticHint" },
  MiniDepsInfo          = { link = "DiagnosticInfo" },
  MiniDepsMsgBreaking   = { link = "DiagnosticWarn" },
  MiniDepsPlaceholder   = { link = "Comment" },
  MiniDepsTitle         = { link = "Title" },
  MiniDepsTitleError    = { link = "DiffDelete" },
  MiniDepsTitleSame     = { link = "DiffChange" },
  MiniDepsTitleUpdate   = { link = "DiffAdd" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniDiffOverAdd     = { link = "DiffAdd" },
  MiniDiffOverChange  = { link = "DiffText" },
  MiniDiffOverContext = { link = "DiffChange" },
  MiniDiffOverDelete  = { link = "DiffDelete" },
  MiniDiffSignAdd     = { link = "Added" },
  MiniDiffSignChange  = { link = "Changed" },
  MiniDiffSignDelete  = { link = "Removed" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniFilesBorder         = { link = "FloatBorder" },
  MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
  MiniFilesCursorLine     = { link = "CursorLineFloat" },
  MiniFilesDirectory      = { link = "Directory" },
  MiniFilesFile           = { link = "NormalFloat" },
  MiniFilesNormal         = { link = "NormalFloat" },
  MiniFilesTitle          = { link = "FloatTitle" },
  MiniFilesTitleFocused   = { link = "FloatTitleFocused" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniIconsAzure   = { link = "Blue" },
  MiniIconsBlue    = { link = "Blue" },
  MiniIconsCyan    = { link = "Aqua" },
  MiniIconsGreen   = { link = "Green" },
  MiniIconsGrey    = { link = "Grey" },
  MiniIconsOrange  = { link = "Orange" },
  MiniIconsMagenta = { link = "Purple" },
  MiniIconsRed     = { link = "Red" },
  MiniIconsYellow  = { link = "Yellow" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniIndentscopeSymbol    = { link = "White" },
  MiniIndentscopeSymbolOff = { link = "Red" },
  -- stylua: ignore end

  MiniJump = { fg = palette.red, reverse = true },

  -- stylua: ignore start
  MiniJump2dDim        = { link = "Comment" },
  MiniJump2dSpot       = { link = "Orange" },
  MiniJump2dSpotAhead  = { link = "Aqua" },
  MiniJump2dSpotUnique = { link = "Yellow" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniMapNormal      = { link = "NormalFloat" },
  MiniMapSymbolCount = { link = "Special" },
  MiniMapSymbolLine  = { link = "Title" },
  MiniMapSymbolView  = { link = "Delimiter" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniNotifyBorder      = { link = "FloatBorder" },
  MiniNotifyNormal      = { link = "NormalFloat" },
  MiniNotifyTitle       = { link = "FloatTitle" },
  MiniNotifyLspProgress = { fg   = palette.blue, italic = true },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniOperatorsExchangeFrom = { link = "IncSearch" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniSnippetsCurrent        = { link = "DiagnosticUnderlineWarn" },
  MiniSnippetsCurrentReplace = { link = "DiagnosticUnderlineError" },
  MiniSnippetsFinal          = { link = "DiagnosticUnderlineOk" },
  MiniSnippetsUnvisited      = { link = "DiagnosticUnderlineHint" },
  MiniSnippetsVisited        = { link = "DiagnosticUnderlineInfo" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniStarterCurrent    = { link = "Normal" },
  MiniStarterFooter     = { link = "Blue" },
  MiniStarterHeader     = { link = "Yellow" },
  MiniStarterInactive   = { link = "Comment" },
  MiniStarterItem       = { link = "Normal" },
  MiniStarterItemBullet = { link = "Grey" },
  MiniStarterItemPrefix = { link = "Yellow" },
  MiniStarterQuery      = { link = "Blue" },
  MiniStarterSection    = { link = "Title" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniStatuslineModeCommand = { fg = palette.bg0, bg = palette.aqua },
  MiniStatuslineModeInsert  = { fg = palette.bg0, bg = palette.fg },
  MiniStatuslineModeNormal  = { fg = palette.bg0, bg = palette.green },
  MiniStatuslineModeOther   = { fg = palette.bg0, bg = palette.purple },
  MiniStatuslineModeReplace = { fg = palette.bg0, bg = palette.orange },
  MiniStatuslineModeVisual  = { fg = palette.bg0, bg = palette.red },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniStatuslineDevinfo  = { fg = palette.grey2, bg = palette.bg1 },
  MiniStatuslineFilename = { fg = palette.grey2, bg = palette.bg2 },
  MiniStatuslineFileinfo = { fg = palette.grey2, bg = palette.bg1 },
  MiniStatuslineInactive = { fg = palette.grey2, bg = palette.bg1 },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniSurround = { link = "IncSearch" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniTablineCurrent         = { link = "TabLineSel" },
  MiniTablineHidden          = { link = "TabLine" },
  MiniTablineFill            = { link = "TabLineFill" },
  MiniTablineModifiedCurrent = { link = "TabLineSel" },
  MiniTablineModifiedHidden  = { link = "TabLine" },
  MiniTablineModifiedVisible = { link = "TabLine" },
  MiniTablineTabpagesection  = { link = "TabLineFill" },
  MiniTablineVisible         = { link = "TabLine" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniTestEmphasis = { link = "Bold" },
  MiniTestFail     = { link = "Red" },
  MiniTestPass     = { link = "Green" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniTrailspace = { bg = palette.red },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniPickBorder        = { link  = "FloatBorder" },
  MiniPickBorderBusy    = { link  = "DiagnosticFloatingWarn" },
  MiniPickBorderText    = { link  = "FloatTitle" },
  MiniPickCursor        = { blend = 100, nocombine = true },
  MiniPickIconDirectory = { link  = "Directory" },
  MiniPickIconFile      = { link  = "MiniPickNormal" },
  MiniPickHeader        = { link  = "DiagnosticFloatingHint" },
  MiniPickMatchCurrent  = { link  = "CursorLineFloat" },
  MiniPickMatchMarked   = { link  = "Visual" },
  MiniPickMatchRanges   = { link  = "DiagnosticFloatingHint" },
  MiniPickNormal        = { link  = "NormalFloat" },
  MiniPickPreviewLine   = { link  = "CursorLineFloat" },
  MiniPickPreviewRegion = { link  = "IncSearch" },
  MiniPickPrompt        = { link  = "DiagnosticFloatingInfo" },
  MiniPickPromptCaret   = { link  = "MiniPickPrompt" },
  MiniPickPromptPrefix  = { link  = "MiniPickPrompt" },
  -- stylua: ignore end

  -- https://github.com/mason-org/mason.nvim
  -- stylua: ignore start
  MasonHeader          = { fg = palette.green, reverse = true },
  MasonHeaderSecondary = { fg = palette.green, reverse = true },
  MasonHighlight                   = { fg = palette.green },
  MasonHighlightSecondary          = { fg = palette.green },
  MasonHighlightBlock              = { fg = palette.aqua,   bg = palette.bg0, reverse = true },
  MasonHighlightBlockBold          = { fg = palette.aqua,   bg = palette.bg0, reverse = true },
  MasonHighlightBlockSecondary     = { fg = palette.yellow, bg = palette.bg0, reverse = true },
  MasonHighlightBlockBoldSecondary = { fg = palette.yellow, bg = palette.bg0, reverse = true },
  MasonMuted                       = { fg = palette.grey0 },
  MasonMutedBlock                  = { fg = palette.bg0, bg = palette.grey0 },
  -- stylua: ignore end
}

local hl = function(group, opts)
  if not opts.link then
    opts.fg = opts.fg or "NONE"
    opts.bg = opts.bg or "NONE"
  end
  vim.api.nvim_set_hl(0, group, opts)
end

for group, opts in pairs(highlights) do
  hl(group, opts)
end
