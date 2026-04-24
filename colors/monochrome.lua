vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end

vim.g.colors_name = "monochrome"

-- Configuration ---------------------------------------------------------------
-- Select a color by setting `vim.g.monochrome_color` to one of:
-- blue | cyan | green | magenta | orange | pink | red | violet | yellow
-- before `:colorscheme monochrome`.

local base_hex
local palette_opts = {}

if vim.g.monochrome_color == "blue" then
  base_hex = "#4fa8c8"
elseif vim.g.monochrome_color == "cyan" then
  base_hex = "#40e0e8"
elseif vim.g.monochrome_color == "green" then
  base_hex = "#4fc89a"
elseif vim.g.monochrome_color == "magenta" then
  base_hex = "#e850e8"
elseif vim.g.monochrome_color == "orange" then
  base_hex = "#e8703a"
elseif vim.g.monochrome_color == "pink" then
  base_hex = "#e850a0"
elseif vim.g.monochrome_color == "red" then
  base_hex = "#e85068"
elseif vim.g.monochrome_color == "violet" then
  base_hex = "#9050e8"
elseif vim.g.monochrome_color == "yellow" then
  base_hex = "#e8d040"
else
  vim.notify("Not a valid monochrome_color: " .. tostring(vim.g.monochrome_color), vim.log.levels.ERROR)
  return
end

local mono = require("mini_plugins.colors")
local p = mono.gen_monochrome_palette(base_hex, palette_opts)
if p == nil then
  vim.notify("monochrome: invalid base hue " .. tostring(base_hex), vim.log.levels.ERROR)
  return
end

local function shade(l, s)
  return mono.shade(base_hex, math.min(100, l), math.min(100, s), palette_opts)
end

-- Chromatic shades (flavor-tinted) ------------------------------------------
local darker  = shade(30, 55)
local dark    = shade(50, 50)
local normal  = shade(70, 70)
local light   = shade(82, 85)
local lighter = shade(92, 88)

-- Achromatic shades (pure grey) ---------------------------------------------
local low  = mono.shade(base_hex, 12, 0, palette_opts)
local mid  = mono.shade(base_hex, 30, 0, palette_opts)
local high = mono.shade(base_hex, 55, 0, palette_opts)

local bg = "#161616"

-- A couple of hue-shifted tints for diff bg. Derived from the base palette but
-- pulled slightly toward green/red in lightness so add/delete read distinctly
-- without breaking the monochrome feel.

-- stylua: ignore start
local bg_red    = "#4c3432"
local bg_orange = "#4a3a2f"
local bg_yellow = "#4f422e"
local bg_green  = "#3b4439"
local bg_cyan   = "#364544"
local bg_blue   = "#374141"
local bg_purple = "#443840"

local diff_add    = bg_green
local diff_change = bg_blue
local diff_delete = bg_red
-- stylua: ignore end

-- Accent colors for icons, git signs, diagnostics.
-- stylua: ignore start
local red    = "#e67e80"
local orange = "#e69875"
local yellow = "#dbbc7f"
local green  = "#a7c080"
local cyan   = "#83c092"
local blue   = "#7fbbb3"
local purple = "#d699b6"
local grey   = "#859289"
local white  = "#ffffff"
-- stylua: ignore end

local highlights = {
  Normal = { fg = normal, bg = bg },
  NormalNC = { fg = normal, bg = bg },
  NormalFloat = { fg = normal, bg = low },

  FloatBorder = { fg = dark, bg = low },
  FloatTitle = { fg = light, bg = low, bold = true },
  EndOfBuffer = { fg = mid },
  Folded = { fg = dark, bg = low, italic = true },
  FoldColumn = { fg = dark },
  SignColumn = { bg = "NONE" },

  ColorColumn = { bg = mid },
  CursorColumn = { bg = low },
  CursorLine = { bg = low },
  CursorLineNr = { fg = light, bold = true },
  LineNr = { fg = dark },
  LineNrAbove = { fg = dark },
  LineNrBelow = { fg = dark },

  Cursor = { fg = bg, bg = lighter },
  lCursor = { fg = bg, bg = lighter },
  CursorIM = { fg = bg, bg = lighter },
  TermCursor = { fg = bg, bg = lighter },
  TermCursorNC = { fg = bg, bg = dark },

  -- Per-Mode Cursors (Wired Via `guicursor`) ---------------------------------
  CursorNormal = { fg = bg, bg = normal },
  CursorInsert = { fg = bg, bg = lighter },
  CursorVisual = { fg = bg, bg = lighter },
  CursorReplace = { fg = bg, bg = light },
  CursorCommand = { fg = normal, bg = dark },

  Visual = { bg = low },
  VisualNOS = { bg = low },

  Search = { fg = bg, bg = normal, bold = true },
  IncSearch = { fg = bg, bg = lighter, bold = true },
  CurSearch = { fg = bg, bg = lighter, bold = true },
  Substitute = { fg = bg, bg = lighter },
  MatchParen = { fg = lighter, bold = true, underline = true },

  Conceal = { fg = dark },
  NonText = { fg = mid },
  SpecialKey = { fg = mid },
  Whitespace = { fg = mid },

  Pmenu = { fg = normal, bg = low },
  PmenuSel = { fg = bg, bg = normal, bold = true },
  PmenuKind = { fg = normal, bg = low },
  PmenuKindSel = { fg = bg, bg = normal },
  PmenuExtra = { fg = dark, bg = low },
  PmenuSbar = { bg = low },
  PmenuThumb = { bg = dark },
  PmenuMatch = { fg = lighter, bold = true },
  PmenuMatchSel = { fg = bg, bold = true },
  WildMenu = { fg = bg, bg = normal },
  MsgArea = { fg = normal, bg = bg },

  StatusLine = { fg = light, bg = low, bold = true },
  StatusLineNC = { fg = dark, bg = low },
  StatusLineTerm = { fg = normal, bg = low },
  StatusLineTermNC = { fg = dark, bg = low },

  TabLine = { fg = dark, bg = low },
  TabLineFill = { fg = green, bg = low },
  TabLineSel = { fg = normal, bg = low },

  WinBar = { fg = light, bg = bg, bold = true },
  WinBarNC = { fg = dark, bg = bg },
  VertSplit = { fg = mid, bg = bg },
  WinSeparator = { fg = mid, bg = bg },

  Directory = { fg = light, bold = true },
  Title = { fg = lighter, bold = true },
  ErrorMsg = { fg = light, bold = true, underline = true },
  WarningMsg = { fg = light, bold = true },
  MoreMsg = { fg = light, bold = true },
  ModeMsg = { fg = light, bold = true },
  Question = { fg = light, bold = true },
  QuickFixLine = { bg = low, bold = true },

  -- Spell --------------------------------------------------------------------
  SpellBad = { undercurl = true, sp = normal },
  SpellCap = { undercurl = true, sp = dark },
  SpellLocal = { undercurl = true, sp = dark },
  SpellRare = { undercurl = true, sp = dark },

  -- Diff ---------------------------------------------------------------------
  DiffAdd = { bg = diff_add },
  DiffChange = { bg = diff_change },
  DiffDelete = { fg = dark, bg = diff_delete },
  DiffText = { bg = mid, bold = true },
  Added = { fg = green, bold = true },
  Removed = { fg = red, italic = true },
  Changed = { fg = blue },

  -- Syntax -------------------------------------------------------------------
  Comment = { fg = high, italic = true },
  SpecialComment = { fg = high, bold = true, italic = true },
  Constant = { fg = normal },
  String = { fg = normal },
  Character = { fg = normal },
  Number = { fg = normal },
  Boolean = { fg = lighter, bold = true },
  Float = { fg = normal },
  Identifier = { fg = normal },
  Function = { fg = light, bold = true },
  Statement = { fg = lighter, bold = true },
  Conditional = { fg = lighter, bold = true },
  Repeat = { fg = lighter, bold = true },
  Label = { fg = light, bold = true },
  Operator = { fg = lighter },
  Keyword = { fg = lighter, bold = true },
  Exception = { fg = lighter, bold = true },
  PreProc = { fg = light, bold = true },
  Include = { fg = light, bold = true },
  Define = { fg = light, bold = true },
  Macro = { fg = light, bold = true },
  PreCondit = { fg = light, bold = true },
  Type = { fg = normal, underline = true },
  StorageClass = { fg = light, bold = true },
  Structure = { fg = normal, underline = true },
  Typedef = { fg = normal, underline = true },
  Special = { fg = normal },
  SpecialChar = { fg = light, bold = true },
  Tag = { fg = normal, underline = true },
  Delimiter = { fg = normal },
  Debug = { fg = normal },
  Underlined = { fg = normal, underline = true },
  Ignore = { fg = mid },
  Error = { fg = light, bold = true, underline = true },
  Todo = { fg = bg, bg = normal, bold = true },

  Bold = { bold = true },
  Italic = { italic = true },
  Underline = { underline = true },
  Strikethrough = { strikethrough = true },

  -- Diagnostics --------------------------------------------------------------
  DiagnosticError = { fg = red, bold = true },
  DiagnosticWarn = { fg = yellow },
  DiagnosticInfo = { fg = blue },
  DiagnosticHint = { fg = cyan, italic = true },
  DiagnosticOk = { fg = green },
  DiagnosticUnderlineError = { undercurl = true, sp = red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = yellow },
  DiagnosticUnderlineInfo = { undercurl = true, sp = blue },
  DiagnosticUnderlineHint = { undercurl = true, sp = cyan },
  DiagnosticUnderlineOk = { undercurl = true, sp = green },
  DiagnosticVirtualTextError = { fg = red, bg = low, bold = true },
  DiagnosticVirtualTextWarn = { fg = yellow, bg = low },
  DiagnosticVirtualTextInfo = { fg = blue, bg = low },
  DiagnosticVirtualTextHint = { fg = cyan, bg = low, italic = true },
  DiagnosticVirtualTextOk = { fg = green, bg = low },
  DiagnosticFloatingError = { fg = red, bold = true },
  DiagnosticFloatingWarn = { fg = yellow },
  DiagnosticFloatingInfo = { fg = blue },
  DiagnosticFloatingHint = { fg = cyan, italic = true },
  DiagnosticFloatingOk = { fg = green },
  DiagnosticSignError = { fg = red, bold = true },
  DiagnosticSignWarn = { fg = yellow },
  DiagnosticSignInfo = { fg = blue },
  DiagnosticSignHint = { fg = cyan },
  DiagnosticSignOk = { fg = green },
  DiagnosticUnnecessary = { fg = dark },
  DiagnosticDeprecated = { strikethrough = true },

  ErrorText = { bg = diff_delete, undercurl = true, sp = red },
  HintText = { bg = low, undercurl = true, sp = cyan },
  InfoText = { bg = low, undercurl = true, sp = blue },
  WarningText = { bg = diff_change, undercurl = true, sp = yellow },

  -- LSP ----------------------------------------------------------------------
  LspReferenceText = { bg = low },
  LspReferenceRead = { bg = low },
  LspReferenceWrite = { bg = low, bold = true },
  LspSignatureActiveParameter = { bg = low, bold = true },
  LspCodeLens = { fg = dark, italic = true },
  LspCodeLensSeparator = { fg = dark },
  LspInlayHint = { fg = dark, bg = low, italic = true },
  LspInfoBorder = { fg = dark, bg = bg },
  InlayHints = { link = "LspInlayHint" },
  CurrentWord = { link = "Underline" },

  -- Treesitter ---------------------------------------------------------------
  ["@variable"] = { fg = normal },
  ["@variable.builtin"] = { fg = lighter, italic = true },
  ["@variable.parameter"] = { fg = normal, italic = true },
  ["@variable.member"] = { fg = normal },
  ["@constant"] = { fg = normal },
  ["@constant.builtin"] = { fg = light, bold = true },
  ["@constant.macro"] = { fg = light, bold = true },
  ["@module"] = { fg = normal },
  ["@label"] = { fg = light, bold = true },
  ["@string"] = { fg = normal },
  ["@string.escape"] = { fg = light, bold = true },
  ["@string.special"] = { fg = light, bold = true },
  ["@character"] = { fg = normal },
  ["@character.special"] = { fg = light, bold = true },
  ["@number"] = { fg = normal },
  ["@number.float"] = { fg = normal },
  ["@boolean"] = { fg = lighter, bold = true },
  ["@float"] = { fg = normal },
  ["@function"] = { fg = lighter, bold = true },
  ["@function.builtin"] = { fg = lighter, bold = true, italic = true },
  ["@function.call"] = { fg = lighter },
  ["@function.macro"] = { fg = light, bold = true },
  ["@function.method"] = { fg = light, bold = true },
  ["@function.method.call"] = { fg = normal },
  ["@method"] = { fg = light, bold = true },
  ["@method.call"] = { fg = normal },
  ["@constructor"] = { fg = light, bold = true },
  ["@keyword"] = { fg = lighter, bold = true },
  ["@keyword.function"] = { fg = lighter, bold = true },
  ["@keyword.operator"] = { fg = lighter },
  ["@keyword.return"] = { fg = lighter, bold = true },
  ["@keyword.import"] = { fg = light, bold = true },
  ["@keyword.modifier"] = { fg = light, bold = true },
  ["@keyword.conditional"] = { fg = lighter, bold = true },
  ["@keyword.repeat"] = { fg = lighter, bold = true },
  ["@keyword.exception"] = { fg = lighter, bold = true },
  ["@conditional"] = { fg = lighter, bold = true },
  ["@repeat"] = { fg = lighter, bold = true },
  ["@exception"] = { fg = lighter, bold = true },
  ["@include"] = { fg = light, bold = true },
  ["@type"] = { fg = normal, underline = true },
  ["@type.builtin"] = { fg = light, underline = true },
  ["@type.definition"] = { fg = normal, underline = true },
  ["@type.qualifier"] = { fg = light, bold = true },
  ["@attribute"] = { fg = normal },
  ["@field"] = { fg = normal },
  ["@property"] = { fg = normal },
  ["@parameter"] = { fg = normal, italic = true },
  ["@operator"] = { fg = lighter },
  ["@namespace"] = { fg = normal },
  ["@punctuation"] = { fg = normal },
  ["@punctuation.bracket"] = { fg = normal },
  ["@punctuation.delimiter"] = { fg = normal },
  ["@punctuation.special"] = { fg = light, bold = true },
  ["@comment"] = { link = "Comment" },
  ["@comment.documentation"] = { fg = high, italic = true },
  ["@comment.error"] = { fg = light, bold = true },
  ["@comment.warning"] = { fg = normal },
  ["@comment.note"] = { fg = high, italic = true },
  ["@comment.todo"] = { link = "Todo" },
  ["@tag"] = { fg = light, bold = true },
  ["@tag.attribute"] = { fg = normal, italic = true },
  ["@tag.delimiter"] = { fg = normal },
  ["@text"] = { fg = normal },
  ["@text.strong"] = { fg = light, bold = true },
  ["@text.bright"] = { fg = normal, italic = true },
  ["@text.underline"] = { fg = normal, underline = true },
  ["@text.strike"] = { fg = normal, strikethrough = true },
  ["@text.title"] = { fg = lighter, bold = true },
  ["@text.literal"] = { fg = normal },
  ["@text.uri"] = { fg = normal, underline = true },
  ["@text.reference"] = { fg = normal, italic = true },
  ["@diff.plus"] = { bg = diff_add },
  ["@diff.minus"] = { bg = diff_delete },
  ["@diff.delta"] = { bg = diff_change },
  ["@markup.heading"] = { fg = lighter, bold = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.strike"] = { strikethrough = true },
  ["@markup.link"] = { fg = normal, italic = true },
  ["@markup.link.url"] = { fg = normal, underline = true },
  ["@markup.link.label"] = { fg = light, bold = true },
  ["@markup.raw"] = { bg = low },
  ["@markup.list"] = { fg = dark },
  ["@markup.quote"] = { fg = dark, italic = true },

  -- Semantic tokens ----------------------------------------------------------
  ["@lsp.type.class"] = { fg = normal, underline = true },
  ["@lsp.type.struct"] = { fg = normal, underline = true },
  ["@lsp.type.interface"] = { fg = normal, underline = true },
  ["@lsp.type.enum"] = { fg = normal, underline = true },
  ["@lsp.type.enumMember"] = { fg = normal },
  ["@lsp.type.parameter"] = { fg = normal, italic = true },
  ["@lsp.type.variable"] = { fg = lighter },
  ["@lsp.type.property"] = { fg = normal },
  ["@lsp.type.function"] = { fg = lighter, bold = true },
  ["@lsp.type.method"] = { fg = light, bold = true },
  ["@lsp.type.macro"] = { fg = light, bold = true },
  ["@lsp.type.keyword"] = { fg = lighter, bold = true },
  ["@lsp.type.modifier"] = { fg = light, bold = true },
  ["@lsp.type.namespace"] = { fg = normal },
  ["@lsp.type.number"] = { fg = normal },
  ["@lsp.type.operator"] = { fg = lighter },
  ["@lsp.type.string"] = { fg = normal },
  ["@lsp.type.regexp"] = { fg = light, bold = true },
  ["@lsp.type.type"] = { fg = normal, underline = true },
  ["@lsp.type.typeParameter"] = { fg = normal, italic = true },
  ["@lsp.type.decorator"] = { fg = light, bold = true },
  ["@lsp.type.comment"] = { link = "Comment" },
  ["@lsp.mod.defaultLibrary"] = { fg = lighter, italic = true },

  -- https://github.com/nvim-mini/mini.nvim
  MiniAnimateCursor = { reverse = true, nocombine = true },
  MiniAnimateNormalFloat = { link = "NormalFloat" },

  MiniClueBorder = { link = "FloatBorder" },
  MiniClueDescGroup = { fg = normal, bg = low },
  MiniClueDescSingle = { fg = normal, bg = low },
  MiniClueNextKey = { fg = dark, bg = low, bold = true },
  MiniClueNextKeyWithPostkeys = { fg = red, bg = low, bold = true },
  MiniClueSeparator = { fg = dark, bg = low },
  MiniClueTitle = { link = "FloatTitle" },

  MiniCmdlinePeekBorder = { link = "FloatBorder" },
  MiniCmdlinePeekLineNr = { fg = light },
  MiniCmdlinePeekNormal = { link = "NormalFloat" },
  MiniCmdlinePeekSep = { link = "SignColumn" },
  MiniCmdlinePeekSign = { fg = dark },
  MiniCmdlinePeekTitle = { link = "FloatTitle" },

  MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
  MiniCompletionDeprecated = { link = "Strikethrough" },
  MiniCompletionInfoBorderOutdated = { fg = light, bg = low },

  MiniCursorword = { link = "Underline" },
  MiniCursorwordCurrent = { link = "Underline" },

  MiniDepsChangeAdded = { link = "Added" },
  MiniDepsChangeRemoved = { link = "Removed" },
  MiniDepsHints = { fg = dark, italic = true },
  MiniDepsInfo = { fg = normal },
  MiniDepsMsgBreaking = { fg = light, bold = true },
  MiniDepsPlaceholder = { link = "Comment" },
  MiniDepsTitle = { link = "Title" },
  MiniDepsTitleError = { link = "DiffDelete" },
  MiniDepsTitleSame = { link = "DiffChange" },
  MiniDepsTitleUpdate = { link = "DiffAdd" },

  MiniDiffOverAdd = { link = "DiffAdd" },
  MiniDiffOverChange = { link = "DiffText" },
  MiniDiffOverContext = { link = "DiffChange" },
  MiniDiffOverDelete = { link = "DiffDelete" },
  MiniDiffSignAdd = { link = "Added" },
  MiniDiffSignChange = { link = "Changed" },
  MiniDiffSignDelete = { link = "Removed" },

  MiniFilesBorder = { link = "FloatBorder" },
  MiniFilesBorderModified = { fg = light, bg = low, bold = true },
  MiniFilesCursorLine = { bg = low },
  MiniFilesDirectory = { link = "Directory" },
  MiniFilesFile = { link = "NormalFloat" },
  MiniFilesNormal = { link = "NormalFloat" },
  MiniFilesTitle = { link = "FloatTitle" },
  MiniFilesTitleFocused = { link = "FloatTitle" },

  MiniIconsAzure = { link = "Blue" },
  MiniIconsBlue = { link = "Blue" },
  MiniIconsCyan = { link = "Cyan" },
  MiniIconsGreen = { link = "Green" },
  MiniIconsGrey = { link = "Grey" },
  MiniIconsOrange = { link = "Orange" },
  MiniIconsPurple = { link = "Purple" },
  MiniIconsRed = { link = "Red" },
  MiniIconsYellow = { link = "Yellow" },

  MiniIndentscopeSymbol = { fg = lighter },
  MiniIndentscopeSymbolOff = { fg = red },

  MiniJump = { fg = bg, bg = lighter, bold = true },
  MiniJump2dDim = { link = "Comment" },
  MiniJump2dSpot = { fg = lighter, bold = true },
  MiniJump2dSpotAhead = { fg = normal, bold = true },
  MiniJump2dSpotUnique = { fg = light, bold = true, underline = true },

  MiniMapNormal = { link = "NormalFloat" },
  MiniMapSymbolCount = { link = "Special" },
  MiniMapSymbolLine = { link = "Title" },
  MiniMapSymbolView = { link = "Delimiter" },

  MiniNotifyBorder = { link = "FloatBorder" },
  MiniNotifyNormal = { link = "NormalFloat" },
  MiniNotifyTitle = { link = "FloatTitle" },
  MiniNotifyLspProgress = { fg = dark, italic = true },

  MiniOperatorsExchangeFrom = { link = "IncSearch" },

  MiniPickBorder = { link = "FloatBorder" },
  MiniPickBorderBusy = { fg = light, bg = low },
  MiniPickBorderText = { link = "FloatTitle" },
  MiniPickCursor = { blend = 100, nocombine = true },
  MiniPickIconDirectory = { link = "Directory" },
  MiniPickIconFile = { link = "MiniPickNormal" },
  MiniPickHeader = { fg = lighter, bg = low, bold = true },
  MiniPickMatchCurrent = { bg = low },
  MiniPickMatchMarked = { link = "Visual" },
  MiniPickMatchRanges = { fg = lighter, bold = true, underline = true },
  MiniPickNormal = { link = "NormalFloat" },
  MiniPickPreviewLine = { bg = low },
  MiniPickPreviewRegion = { link = "IncSearch" },
  MiniPickPrompt = { fg = normal, bg = low, bold = true },
  MiniPickPromptCaret = { link = "MiniPickPrompt" },
  MiniPickPromptPrefix = { link = "MiniPickPrompt" },

  MiniSnippetsCurrent = { undercurl = true, sp = light },
  MiniSnippetsCurrentReplace = { undercurl = true, sp = red },
  MiniSnippetsFinal = { undercurl = true, sp = green },
  MiniSnippetsUnvisited = { undercurl = true, sp = cyan },
  MiniSnippetsVisited = { undercurl = true, sp = blue },

  MiniStarterCurrent = { link = "Normal" },
  MiniStarterFooter = { fg = dark },
  MiniStarterHeader = { fg = normal, bold = true },
  MiniStarterInactive = { link = "Comment" },
  MiniStarterItem = { link = "Normal" },
  MiniStarterItemBullet = { fg = dark },
  MiniStarterItemPrefix = { fg = light, bold = true },
  MiniStarterQuery = { fg = lighter, bold = true },
  MiniStarterSection = { link = "Title" },

  MiniStatuslineModeNormal = { fg = bg, bg = normal, bold = true },
  MiniStatuslineModeInsert = { fg = bg, bg = lighter, bold = true },
  MiniStatuslineModeVisual = { fg = bg, bg = cyan, bold = true },
  MiniStatuslineModeReplace = { fg = bg, bg = red, bold = true },
  MiniStatuslineModeCommand = { fg = bg, bg = dark, bold = true },
  MiniStatuslineModeOther = { fg = bg, bg = dark, bold = true },

  MiniStatuslineDevinfo = { fg = dark, bg = low },
  MiniStatuslineFilename = { fg = dark, bg = low },
  MiniStatuslineFileinfo = { fg = dark, bg = low },
  MiniStatuslineInactive = { fg = dark, bg = low },

  MiniSurround = { link = "IncSearch" },

  MiniTablineCurrent = { link = "TabLineSel" },
  MiniTablineHidden = { link = "TabLine" },
  MiniTablineFill = { link = "TabLineFill" },
  MiniTablineModifiedCurrent = { link = "TabLineSel" },
  MiniTablineModifiedHidden = { link = "TabLine" },
  MiniTablineModifiedVisible = { link = "TabLine" },
  MiniTablineTabpagesection = { link = "TabLineFill" },
  MiniTablineVisible = { link = "TabLine" },

  MiniTestEmphasis = { link = "Bold" },
  MiniTestFail = { link = "Red" },
  MiniTestPass = { link = "Green" },

  MiniTrailspace = { bg = red },

  -- https://github.com/mason-org/mason.nvim
  MasonHeader = { fg = lighter, reverse = true },
  MasonHeaderSecondary = { fg = lighter, reverse = true },
  MasonHighlight = { fg = lighter },
  MasonHighlightSecondary = { fg = lighter },
  MasonHighlightBlock = { fg = normal, bg = bg, reverse = true },
  MasonHighlightBlockBold = { fg = normal, bg = bg, reverse = true, bold = true },
  MasonHighlightBlockSecondary = { fg = light, bg = bg, reverse = true },
  MasonHighlightBlockBoldSecondary = { fg = light, bg = bg, reverse = true, bold = true },
  MasonMuted = { fg = dark },
  MasonMutedBlock = { fg = bg, bg = dark },

  -- https://github.com/igorlfs/nvim-dap-view
  NvimDapViewTab = { fg = dark, bg = bg },
  NvimDapViewTabSelected = { fg = normal, bg = bg, bold = true },
  NvimDapViewTabFill = { fg = dark, bg = bg },

  -- https://github.com/mistweaverco/kulala.nvim
  KulalaTab = { fg = dark, bg = low },
  KulalaTabSel = { fg = normal, bg = low, bold = true },

  -- https://github.com/HiPhish/rainbow-delimiters.nvim
  RainbowDelimiterRed = { fg = darker },
  RainbowDelimiterOrange = { fg = dark },
  RainbowDelimiterYellow = { fg = normal },

  -- Predefined groups used by linked highlights ------------------------------
  Fg = { fg = normal },
  Grey = { fg = grey },
  White = { fg = white },
  Red = { fg = red },
  Orange = { fg = orange },
  Yellow = { fg = yellow },
  Green = { fg = green },
  Cyan = { fg = cyan },
  Blue = { fg = blue },
  Purple = { fg = purple },

  -- Tinted BG Groups (Read By `config/highlight.lua` For Yank/Paste/Undo/Redo)
  BgRed = { bg = bg_red },
  BgOrange = { bg = bg_orange },
  BgYellow = { bg = bg_yellow },
  BgGreen = { bg = bg_green },
  BgCyan = { bg = bg_cyan },
  BgBlue = { bg = bg_blue },
  BgPurple = { bg = bg_purple },
}

for group, opts in pairs(highlights) do
  if not opts.link then
    opts.fg = opts.fg or "NONE"
    opts.bg = opts.bg or "NONE"
  end
  vim.api.nvim_set_hl(0, group, opts)
end

-- Terminal palette (monochrome gradient) -------------------------------------
vim.g.terminal_color_0 = low
vim.g.terminal_color_1 = lighter
vim.g.terminal_color_2 = normal
vim.g.terminal_color_3 = normal
vim.g.terminal_color_4 = dark
vim.g.terminal_color_5 = lighter
vim.g.terminal_color_6 = normal
vim.g.terminal_color_7 = mid
vim.g.terminal_color_8 = dark
vim.g.terminal_color_9 = lighter
vim.g.terminal_color_10 = lighter
vim.g.terminal_color_11 = lighter
vim.g.terminal_color_12 = normal
vim.g.terminal_color_13 = lighter
vim.g.terminal_color_14 = normal
vim.g.terminal_color_15 = lighter
