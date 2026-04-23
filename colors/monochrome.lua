vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end

vim.g.colors_name = "monochrome"

-- Configuration ---------------------------------------------------------------
-- Select a flavor by setting `vim.g.monochrome_flavor` to one of:
-- amber | amethyst | azurite | garnet | jade | onyx | ruby | tanzanite | topaz
-- before `:colorscheme monochrome`.

local base_hex
local palette_opts = {}

if vim.g.monochrome_flavor == "amber" then
  base_hex = "#c8a84f"
elseif vim.g.monochrome_flavor == "amethyst" then
  base_hex = "#c04fc8"
elseif vim.g.monochrome_flavor == "azurite" then
  base_hex = "#4fa8c8"
elseif vim.g.monochrome_flavor == "garnet" then
  base_hex = "#c8554f"
elseif vim.g.monochrome_flavor == "jade" then
  base_hex = "#4fc89a"
elseif vim.g.monochrome_flavor == "onyx" then
  base_hex = "#808080"
  palette_opts.achromatic = true
elseif vim.g.monochrome_flavor == "ruby" then
  base_hex = "#c84f65"
elseif vim.g.monochrome_flavor == "tanzanite" then
  base_hex = "#654fc8"
elseif vim.g.monochrome_flavor == "topaz" then
  base_hex = "#c88a4f"
else
  vim.notify("Not a valid monochrome_flavor: " .. tostring(vim.g.monochrome_flavor), vim.log.levels.ERROR)
  return
end

local mono = require("mini_plugins.colors")
local p = mono.gen_monochrome_palette(base_hex, palette_opts)
if p == nil then
  vim.notify("monochrome: invalid base hue " .. tostring(base_hex), vim.log.levels.ERROR)
  return
end

-- Shade map: shade_0 darkest -> shade_9 brightest.
local bg_dim = p.shade_0
local comment_fg = mono.shade(base_hex, 48, 0, palette_opts)
local nontext_fg = mono.shade(base_hex, 32, 0, palette_opts)
local cursor_line_bg = mono.shade(base_hex, 15, 0, palette_opts)
local bg = "#161616"
-- local bg = p.shade_1
local cursor = p.shade_2
local visual = p.shade_3
local subtle = p.shade_4
local border = p.shade_5
local dim = p.shade_6
local fg = p.shade_7
local emphasis = p.shade_8
local bright = p.shade_9

local float_bg = visual

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
  Normal = { fg = fg, bg = bg },
  NormalNC = { fg = fg, bg = bg },
  NormalFloat = { fg = fg, bg = float_bg },

  FloatBorder = { fg = dim, bg = float_bg },
  FloatTitle = { fg = emphasis, bg = float_bg, bold = true },
  EndOfBuffer = { fg = subtle },
  Folded = { fg = dim, bg = cursor, italic = true },
  FoldColumn = { fg = dim },
  SignColumn = { bg = "NONE" },

  ColorColumn = { bg = subtle },
  CursorColumn = { bg = visual },
  CursorLine = { bg = visual },
  CursorLineNr = { fg = emphasis, bold = true },
  LineNr = { fg = dim },
  LineNrAbove = { fg = dim },
  LineNrBelow = { fg = dim },

  Cursor = { fg = bg, bg = bright },
  lCursor = { fg = bg, bg = bright },
  CursorIM = { fg = bg, bg = bright },
  TermCursor = { fg = bg, bg = bright },
  TermCursorNC = { fg = bg, bg = dim },

  -- Per-Mode Cursors (Wired Via `guicursor`) ---------------------------------
  CursorNormal = { fg = bg, bg = fg },
  CursorInsert = { fg = bg, bg = bright },
  CursorVisual = { fg = bg, bg = bright },
  CursorReplace = { fg = bg, bg = emphasis },
  CursorCommand = { fg = fg, bg = dim },

  Visual = { bg = visual },
  VisualNOS = { bg = visual },

  Search = { fg = bg, bg = fg, bold = true },
  IncSearch = { fg = bg, bg = bright, bold = true },
  CurSearch = { fg = bg, bg = bright, bold = true },
  Substitute = { fg = bg, bg = bright },
  MatchParen = { fg = bright, bold = true, underline = true },

  Conceal = { fg = dim },
  NonText = { fg = nontext_fg },
  SpecialKey = { fg = subtle },
  Whitespace = { fg = subtle },

  Pmenu = { fg = fg, bg = float_bg },
  PmenuSel = { fg = bg, bg = fg, bold = true },
  PmenuKind = { fg = fg, bg = float_bg },
  PmenuKindSel = { fg = bg, bg = fg },
  PmenuExtra = { fg = dim, bg = float_bg },
  PmenuSbar = { bg = float_bg },
  PmenuThumb = { bg = dim },
  PmenuMatch = { fg = bright, bold = true },
  PmenuMatchSel = { fg = bg, bold = true },
  WildMenu = { fg = bg, bg = fg },
  MsgArea = { fg = fg, bg = bg },

  StatusLine = { fg = emphasis, bg = cursor, bold = true },
  StatusLineNC = { fg = dim, bg = cursor },
  StatusLineTerm = { fg = fg, bg = cursor },
  StatusLineTermNC = { fg = dim, bg = cursor },

  TabLine = { fg = dim, bg = cursor },
  TabLineFill = { fg = green, bg = cursor },
  TabLineSel = { fg = fg, bg = cursor },

  WinBar = { fg = emphasis, bg = bg, bold = true },
  WinBarNC = { fg = dim, bg = bg },
  VertSplit = { fg = border, bg = bg },
  WinSeparator = { fg = border, bg = bg },

  Directory = { fg = emphasis, bold = true },
  Title = { fg = bright, bold = true },
  ErrorMsg = { fg = emphasis, bold = true, underline = true },
  WarningMsg = { fg = emphasis, bold = true },
  MoreMsg = { fg = emphasis, bold = true },
  ModeMsg = { fg = emphasis, bold = true },
  Question = { fg = emphasis, bold = true },
  QuickFixLine = { bg = cursor, bold = true },

  -- Spell --------------------------------------------------------------------
  SpellBad = { undercurl = true, sp = fg },
  SpellCap = { undercurl = true, sp = dim },
  SpellLocal = { undercurl = true, sp = dim },
  SpellRare = { undercurl = true, sp = dim },

  -- Diff ---------------------------------------------------------------------
  DiffAdd = { bg = diff_add },
  DiffChange = { bg = diff_change },
  DiffDelete = { fg = dim, bg = diff_delete },
  DiffText = { bg = subtle, bold = true },
  Added = { fg = green, bold = true },
  Removed = { fg = red, italic = true },
  Changed = { fg = blue },

  -- Syntax -------------------------------------------------------------------
  Comment = { fg = comment_fg, italic = true },
  SpecialComment = { fg = comment_fg, bold = true, italic = true },
  Constant = { fg = fg },
  String = { fg = fg },
  Character = { fg = fg },
  Number = { fg = fg },
  Boolean = { fg = bright, bold = true },
  Float = { fg = fg },
  Identifier = { fg = fg },
  Function = { fg = emphasis, bold = true },
  Statement = { fg = bright, bold = true },
  Conditional = { fg = bright, bold = true },
  Repeat = { fg = bright, bold = true },
  Label = { fg = emphasis, bold = true },
  Operator = { fg = bright },
  Keyword = { fg = bright, bold = true },
  Exception = { fg = bright, bold = true },
  PreProc = { fg = emphasis, bold = true },
  Include = { fg = emphasis, bold = true },
  Define = { fg = emphasis, bold = true },
  Macro = { fg = emphasis, bold = true },
  PreCondit = { fg = emphasis, bold = true },
  Type = { fg = fg, underline = true },
  StorageClass = { fg = emphasis, bold = true },
  Structure = { fg = fg, underline = true },
  Typedef = { fg = fg, underline = true },
  Special = { fg = fg },
  SpecialChar = { fg = emphasis, bold = true },
  Tag = { fg = fg, underline = true },
  Delimiter = { fg = fg },
  Debug = { fg = fg },
  Underlined = { fg = fg, underline = true },
  Ignore = { fg = subtle },
  Error = { fg = emphasis, bold = true, underline = true },
  Todo = { fg = bg, bg = fg, bold = true },

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
  DiagnosticVirtualTextError = { fg = red, bg = cursor, bold = true },
  DiagnosticVirtualTextWarn = { fg = yellow, bg = cursor },
  DiagnosticVirtualTextInfo = { fg = blue, bg = cursor },
  DiagnosticVirtualTextHint = { fg = cyan, bg = cursor, italic = true },
  DiagnosticVirtualTextOk = { fg = green, bg = cursor },
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
  DiagnosticUnnecessary = { fg = dim },
  DiagnosticDeprecated = { strikethrough = true },

  ErrorText = { bg = diff_delete, undercurl = true, sp = red },
  HintText = { bg = cursor, undercurl = true, sp = cyan },
  InfoText = { bg = cursor, undercurl = true, sp = blue },
  WarningText = { bg = diff_change, undercurl = true, sp = yellow },

  -- LSP ----------------------------------------------------------------------
  LspReferenceText = { bg = cursor },
  LspReferenceRead = { bg = cursor },
  LspReferenceWrite = { bg = cursor, bold = true },
  LspSignatureActiveParameter = { bg = visual, bold = true },
  LspCodeLens = { fg = dim, italic = true },
  LspCodeLensSeparator = { fg = dim },
  LspInlayHint = { fg = dim, bg = cursor, italic = true },
  LspInfoBorder = { fg = dim, bg = bg },
  InlayHints = { link = "LspInlayHint" },
  CurrentWord = { link = "Underline" },

  -- Treesitter ---------------------------------------------------------------
  ["@variable"] = { fg = fg },
  ["@variable.builtin"] = { fg = bright, italic = true },
  ["@variable.parameter"] = { fg = fg, italic = true },
  ["@variable.member"] = { fg = fg },
  ["@constant"] = { fg = fg },
  ["@constant.builtin"] = { fg = emphasis, bold = true },
  ["@constant.macro"] = { fg = emphasis, bold = true },
  ["@module"] = { fg = fg },
  ["@label"] = { fg = emphasis, bold = true },
  ["@string"] = { fg = fg },
  ["@string.escape"] = { fg = emphasis, bold = true },
  ["@string.special"] = { fg = emphasis, bold = true },
  ["@character"] = { fg = fg },
  ["@character.special"] = { fg = emphasis, bold = true },
  ["@number"] = { fg = fg },
  ["@number.float"] = { fg = fg },
  ["@boolean"] = { fg = bright, bold = true },
  ["@float"] = { fg = fg },
  ["@function"] = { fg = bright, bold = true },
  ["@function.builtin"] = { fg = bright, bold = true, italic = true },
  ["@function.call"] = { fg = bright },
  ["@function.macro"] = { fg = emphasis, bold = true },
  ["@function.method"] = { fg = emphasis, bold = true },
  ["@function.method.call"] = { fg = fg },
  ["@method"] = { fg = emphasis, bold = true },
  ["@method.call"] = { fg = fg },
  ["@constructor"] = { fg = emphasis, bold = true },
  ["@keyword"] = { fg = bright, bold = true },
  ["@keyword.function"] = { fg = bright, bold = true },
  ["@keyword.operator"] = { fg = bright },
  ["@keyword.return"] = { fg = bright, bold = true },
  ["@keyword.import"] = { fg = emphasis, bold = true },
  ["@keyword.modifier"] = { fg = emphasis, bold = true },
  ["@keyword.conditional"] = { fg = bright, bold = true },
  ["@keyword.repeat"] = { fg = bright, bold = true },
  ["@keyword.exception"] = { fg = bright, bold = true },
  ["@conditional"] = { fg = bright, bold = true },
  ["@repeat"] = { fg = bright, bold = true },
  ["@exception"] = { fg = bright, bold = true },
  ["@include"] = { fg = emphasis, bold = true },
  ["@type"] = { fg = fg, underline = true },
  ["@type.builtin"] = { fg = emphasis, underline = true },
  ["@type.definition"] = { fg = fg, underline = true },
  ["@type.qualifier"] = { fg = emphasis, bold = true },
  ["@attribute"] = { fg = fg },
  ["@field"] = { fg = fg },
  ["@property"] = { fg = fg },
  ["@parameter"] = { fg = fg, italic = true },
  ["@operator"] = { fg = bright },
  ["@namespace"] = { fg = fg },
  ["@punctuation"] = { fg = fg },
  ["@punctuation.bracket"] = { fg = fg },
  ["@punctuation.delimiter"] = { fg = fg },
  ["@punctuation.special"] = { fg = emphasis, bold = true },
  ["@comment"] = { link = "Comment" },
  ["@comment.documentation"] = { fg = comment_fg, italic = true },
  ["@comment.error"] = { fg = emphasis, bold = true },
  ["@comment.warning"] = { fg = fg },
  ["@comment.note"] = { fg = comment_fg, italic = true },
  ["@comment.todo"] = { link = "Todo" },
  ["@tag"] = { fg = emphasis, bold = true },
  ["@tag.attribute"] = { fg = fg, italic = true },
  ["@tag.delimiter"] = { fg = fg },
  ["@text"] = { fg = fg },
  ["@text.strong"] = { fg = emphasis, bold = true },
  ["@text.bright"] = { fg = fg, italic = true },
  ["@text.underline"] = { fg = fg, underline = true },
  ["@text.strike"] = { fg = fg, strikethrough = true },
  ["@text.title"] = { fg = bright, bold = true },
  ["@text.literal"] = { fg = fg },
  ["@text.uri"] = { fg = fg, underline = true },
  ["@text.reference"] = { fg = fg, italic = true },
  ["@diff.plus"] = { bg = diff_add },
  ["@diff.minus"] = { bg = diff_delete },
  ["@diff.delta"] = { bg = diff_change },
  ["@markup.heading"] = { fg = bright, bold = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.strike"] = { strikethrough = true },
  ["@markup.link"] = { fg = fg, italic = true },
  ["@markup.link.url"] = { fg = fg, underline = true },
  ["@markup.link.label"] = { fg = emphasis, bold = true },
  ["@markup.raw"] = { bg = visual },
  ["@markup.list"] = { fg = dim },
  ["@markup.quote"] = { fg = dim, italic = true },

  -- Semantic tokens ----------------------------------------------------------
  ["@lsp.type.class"] = { fg = fg, underline = true },
  ["@lsp.type.struct"] = { fg = fg, underline = true },
  ["@lsp.type.interface"] = { fg = fg, underline = true },
  ["@lsp.type.enum"] = { fg = fg, underline = true },
  ["@lsp.type.enumMember"] = { fg = fg },
  ["@lsp.type.parameter"] = { fg = fg, italic = true },
  ["@lsp.type.variable"] = { fg = bright },
  ["@lsp.type.property"] = { fg = fg },
  ["@lsp.type.function"] = { fg = bright, bold = true },
  ["@lsp.type.method"] = { fg = emphasis, bold = true },
  ["@lsp.type.macro"] = { fg = emphasis, bold = true },
  ["@lsp.type.keyword"] = { fg = bright, bold = true },
  ["@lsp.type.modifier"] = { fg = emphasis, bold = true },
  ["@lsp.type.namespace"] = { fg = fg },
  ["@lsp.type.number"] = { fg = fg },
  ["@lsp.type.operator"] = { fg = bright },
  ["@lsp.type.string"] = { fg = fg },
  ["@lsp.type.regexp"] = { fg = emphasis, bold = true },
  ["@lsp.type.type"] = { fg = fg, underline = true },
  ["@lsp.type.typeParameter"] = { fg = fg, italic = true },
  ["@lsp.type.decorator"] = { fg = emphasis, bold = true },
  ["@lsp.type.comment"] = { link = "Comment" },
  ["@lsp.mod.defaultLibrary"] = { fg = bright, italic = true },

  -- https://github.com/nvim-mini/mini.nvim
  MiniAnimateCursor = { reverse = true, nocombine = true },
  MiniAnimateNormalFloat = { link = "NormalFloat" },

  MiniClueBorder = { link = "FloatBorder" },
  MiniClueDescGroup = { fg = fg, bg = float_bg },
  MiniClueDescSingle = { fg = fg, bg = float_bg },
  MiniClueNextKey = { fg = dim, bg = float_bg, bold = true },
  MiniClueNextKeyWithPostkeys = { fg = red, bg = float_bg, bold = true },
  MiniClueSeparator = { fg = dim, bg = float_bg },
  MiniClueTitle = { link = "FloatTitle" },

  MiniCmdlinePeekBorder = { link = "FloatBorder" },
  MiniCmdlinePeekLineNr = { fg = emphasis },
  MiniCmdlinePeekNormal = { link = "NormalFloat" },
  MiniCmdlinePeekSep = { link = "SignColumn" },
  MiniCmdlinePeekSign = { fg = dim },
  MiniCmdlinePeekTitle = { link = "FloatTitle" },

  MiniCompletionActiveParameter = { link = "LspSignatureActiveParameter" },
  MiniCompletionDeprecated = { link = "Strikethrough" },
  MiniCompletionInfoBorderOutdated = { fg = emphasis, bg = float_bg },

  MiniCursorword = { link = "Underline" },
  MiniCursorwordCurrent = { link = "Underline" },

  MiniDepsChangeAdded = { link = "Added" },
  MiniDepsChangeRemoved = { link = "Removed" },
  MiniDepsHints = { fg = dim, italic = true },
  MiniDepsInfo = { fg = fg },
  MiniDepsMsgBreaking = { fg = emphasis, bold = true },
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
  MiniFilesBorderModified = { fg = emphasis, bg = float_bg, bold = true },
  MiniFilesCursorLine = { bg = cursor },
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

  MiniIndentscopeSymbol = { fg = bright },
  MiniIndentscopeSymbolOff = { fg = red },

  MiniJump = { fg = bg, bg = bright, bold = true },
  MiniJump2dDim = { link = "Comment" },
  MiniJump2dSpot = { fg = bright, bold = true },
  MiniJump2dSpotAhead = { fg = fg, bold = true },
  MiniJump2dSpotUnique = { fg = emphasis, bold = true, underline = true },

  MiniMapNormal = { link = "NormalFloat" },
  MiniMapSymbolCount = { link = "Special" },
  MiniMapSymbolLine = { link = "Title" },
  MiniMapSymbolView = { link = "Delimiter" },

  MiniNotifyBorder = { link = "FloatBorder" },
  MiniNotifyNormal = { link = "NormalFloat" },
  MiniNotifyTitle = { link = "FloatTitle" },
  MiniNotifyLspProgress = { fg = dim, italic = true },

  MiniOperatorsExchangeFrom = { link = "IncSearch" },

  MiniPickBorder = { link = "FloatBorder" },
  MiniPickBorderBusy = { fg = emphasis, bg = float_bg },
  MiniPickBorderText = { link = "FloatTitle" },
  MiniPickCursor = { blend = 100, nocombine = true },
  MiniPickIconDirectory = { link = "Directory" },
  MiniPickIconFile = { link = "MiniPickNormal" },
  MiniPickHeader = { fg = bright, bg = float_bg, bold = true },
  MiniPickMatchCurrent = { bg = cursor },
  MiniPickMatchMarked = { link = "Visual" },
  MiniPickMatchRanges = { fg = bright, bold = true, underline = true },
  MiniPickNormal = { link = "NormalFloat" },
  MiniPickPreviewLine = { bg = cursor },
  MiniPickPreviewRegion = { link = "IncSearch" },
  MiniPickPrompt = { fg = fg, bg = float_bg, bold = true },
  MiniPickPromptCaret = { link = "MiniPickPrompt" },
  MiniPickPromptPrefix = { link = "MiniPickPrompt" },

  MiniSnippetsCurrent = { undercurl = true, sp = emphasis },
  MiniSnippetsCurrentReplace = { undercurl = true, sp = red },
  MiniSnippetsFinal = { undercurl = true, sp = green },
  MiniSnippetsUnvisited = { undercurl = true, sp = cyan },
  MiniSnippetsVisited = { undercurl = true, sp = blue },

  MiniStarterCurrent = { link = "Normal" },
  MiniStarterFooter = { fg = dim },
  MiniStarterHeader = { fg = fg, bold = true },
  MiniStarterInactive = { link = "Comment" },
  MiniStarterItem = { link = "Normal" },
  MiniStarterItemBullet = { fg = dim },
  MiniStarterItemPrefix = { fg = emphasis, bold = true },
  MiniStarterQuery = { fg = bright, bold = true },
  MiniStarterSection = { link = "Title" },

  MiniStatuslineModeNormal = { fg = bg, bg = fg, bold = true },
  MiniStatuslineModeInsert = { fg = bg, bg = bright, bold = true },
  MiniStatuslineModeVisual = { fg = bg, bg = cyan, bold = true },
  MiniStatuslineModeReplace = { fg = bg, bg = red, bold = true },
  MiniStatuslineModeCommand = { fg = bg, bg = dim, bold = true },
  MiniStatuslineModeOther = { fg = bg, bg = dim, bold = true },

  MiniStatuslineDevinfo = { fg = dim, bg = cursor },
  MiniStatuslineFilename = { fg = dim, bg = cursor },
  MiniStatuslineFileinfo = { fg = dim, bg = visual },
  MiniStatuslineInactive = { fg = dim, bg = visual },

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
  MasonHeader = { fg = bright, reverse = true },
  MasonHeaderSecondary = { fg = bright, reverse = true },
  MasonHighlight = { fg = bright },
  MasonHighlightSecondary = { fg = bright },
  MasonHighlightBlock = { fg = fg, bg = bg, reverse = true },
  MasonHighlightBlockBold = { fg = fg, bg = bg, reverse = true, bold = true },
  MasonHighlightBlockSecondary = { fg = emphasis, bg = bg, reverse = true },
  MasonHighlightBlockBoldSecondary = { fg = emphasis, bg = bg, reverse = true, bold = true },
  MasonMuted = { fg = dim },
  MasonMutedBlock = { fg = bg, bg = dim },

  -- https://github.com/igorlfs/nvim-dap-view
  NvimDapViewTab = { fg = dim, bg = bg },
  NvimDapViewTabSelected = { fg = fg, bg = bg, bold = true },
  NvimDapViewTabFill = { fg = dim, bg = bg },

  -- https://github.com/mistweaverco/kulala.nvim
  KulalaTab = { fg = dim, bg = float_bg },
  KulalaTabSel = { fg = fg, bg = float_bg, bold = true },

  -- https://github.com/HiPhish/rainbow-delimiters.nvim
  RainbowDelimiterRed = { fg = p.shade_4 },
  RainbowDelimiterOrange = { fg = p.shade_5 },
  RainbowDelimiterYellow = { fg = p.shade_6 },

  -- Predefined groups used by linked highlights ------------------------------
  Fg = { fg = fg },
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
vim.g.terminal_color_0 = bg_dim
vim.g.terminal_color_1 = bright
vim.g.terminal_color_2 = fg
vim.g.terminal_color_3 = fg
vim.g.terminal_color_4 = dim
vim.g.terminal_color_5 = bright
vim.g.terminal_color_6 = fg
vim.g.terminal_color_7 = subtle
vim.g.terminal_color_8 = dim
vim.g.terminal_color_9 = bright
vim.g.terminal_color_10 = bright
vim.g.terminal_color_11 = bright
vim.g.terminal_color_12 = fg
vim.g.terminal_color_13 = bright
vim.g.terminal_color_14 = fg
vim.g.terminal_color_15 = bright
