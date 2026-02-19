vim.cmd.highlight("clear")
vim.g.colors_name = "gruvbox"

local palette = {
  -- stylua: ignore start
  -- INFO: Neutral colors
  bg_dim      = "#1b1b1b",
  bg0         = "#282828",
  bg1         = "#302e2c",
  bg2         = "#383532",
  bg3         = "#423d39",
  bg4         = "#4d4742",
  bg5         = "#5a524c",

  grey0       = "#7a8478",
  grey1       = "#859289",
  grey2       = "#9da9a0",

  fg          = "#ddc7a1",
  white       = "#ffffff",

  -- INFO: Accent colors (BG)
  bg_red      = "#4c3432",
  bg_orange   = "#4a3a2f",
  bg_yellow   = "#4f422e",
  bg_green    = "#3b4439",
  bg_aqua     = "#364544",
  bg_blue     = "#374141",
  bg_purple   = "#443840",

  -- INFO: Accent colors (FG)
  red         = "#ea6962",
  orange      = "#e78a4e",
  yellow      = "#d8a657",
  green       = "#a9b665",
  aqua        = "#89b482",
  blue        = "#7daea3",
  purple      = "#d3869b",

  none        = "NONE",
  -- stylua: ignore end
}

local highlights = {
  -- INFO: Common Highlight Groups
  -- stylua: ignore start
  Normal       = { fg = palette.fg,    bg = palette.bg0   },
  NormalNC     = { fg = palette.fg,    bg = palette.bg0   },
  Terminal     = { fg = palette.fg,    bg = palette.bg0   },

  EndOfBuffer  = { fg = palette.bg0,   bg = palette.none  },
  Folded       = { fg = palette.grey1, bg = palette.bg2   },

  FoldColumn   = { fg = palette.bg5,   bg = palette.bg0   },
  SignColumn   = { fg = palette.fg,    bg = palette.bg0   },

  Search       = { fg = palette.bg0,   bg = palette.green },
  IncSearch    = { fg = palette.bg0,   bg = palette.red   },
  CurSearch    = { fg = palette.bg0,   bg = palette.red   },

  Substitute   = { fg = palette.bg0, bg   = palette.green },

  ColorColumn  = { fg = palette.none, bg  = palette.bg0   },
  CursorColumn = { fg = palette.none, bg  = palette.bg0   },

  Cursor       = { fg = palette.none,  bg = palette.none  },
  lCursor      = { fg = palette.none,  bg = palette.none  },
  CursorIM     = { fg = palette.none,  bg = palette.none  },
  TermCursor   = { fg = palette.none,  bg = palette.none  },

  CursorLineNr = { fg = palette.fg,   bg = palette.none  },
  CursorLine   = { fg = palette.none, bg = palette.bg1   },

  -- stylua: ignore start
  LineNr       = { fg = palette.grey0, bg = palette.none  },
  LineNrAbove  = { fg = palette.grey0, bg = palette.none  },
  LineNrBelow  = { fg = palette.grey0, bg = palette.none  },
  -- stylua: ignore end

  -- stylua: ignore start
  ToolbarLine   = { fg = palette.fg,  bg = palette.bg2   },
  ToolbarButton = { fg = palette.bg0, bg = palette.grey2 },
  -- stylua: ignore end

  -- stylua: ignore start
  DiffText   = { fg = palette.bg0,  bg = palette.blue     },
  DiffAdd    = { fg = palette.none, bg = palette.bg_green },
  DiffChange = { fg = palette.none, bg = palette.bg_blue  },
  DiffDelete = { fg = palette.none, bg = palette.bg_red   },

  Directory = { fg = palette.green, bg = palette.none },

  ErrorMsg   = { fg = palette.red, bg = palette.none, bold = true, underline = true },

  WarningMsg = { fg = palette.yellow, bg = palette.none, bold = true },
  ModeMsg    = { fg = palette.fg,     bg = palette.none, bold = true },
  MoreMsg    = { fg = palette.yellow, bg = palette.none, bold = true },

  MatchParen = { fg = palette.none,   bg = palette.bg4  },
  NonText    = { fg = palette.bg5,    bg = palette.none },
  Whitespace = { fg = palette.bg4,    bg = palette.none },
  SpecialKey = { fg = palette.orange, bg = palette.none },

  Conceal   =  { fg = palette.grey0,  bg = palette.none },
  -- stylua: ignore end

  -- stylua: ignore start
  Pmenu        = { fg = palette.fg,   bg = palette.bg3   },
  PmenuSel     = { fg = palette.bg3,  bg = palette.grey2 },
  PmenuKind    = { fg = palette.fg,   bg = palette.bg3   },
  PmenuKindSel = { fg = palette.bg3,  bg = palette.grey2 },
  PmenuExtra   = { fg = palette.grey2,bg = palette.bg3   },
  PmenuSbar    = { fg = palette.none, bg = palette.bg3   },
  PmenuThumb   = { fg = palette.none, bg = palette.grey0 },
  WildMenu     = { fg = palette.bg3,  bg = palette.grey2 },
  -- stylua: ignore end

  -- stylua: ignore start
  NormalFloat       = { fg = palette.fg,    bg = palette.bg2 },
  FloatBorder       = { fg = palette.grey1, bg = palette.bg2 },
  FloatTitle        = { fg = palette.grey1, bg = palette.bg2 },
  FloatTitleFocused = { fg = palette.green, bg = palette.bg2 }, -- NOTE: Custom
  -- stylua: ignore end

  -- stylua: ignore start
  SpellBad   = { fg = palette.none, bg = palette.none, undercurl = true, sp = palette.red },
  SpellCap   = { fg = palette.none, bg = palette.none, undercurl = true, sp = palette.blue },
  SpellLocal = { fg = palette.none, bg = palette.none, undercurl = true, sp = palette.aqua },
  SpellRare  = { fg = palette.none, bg = palette.none, undercurl = true, sp = palette.purple },
  -- stylua: ignore end

  -- stylua: ignore start
  WinBar   = { fg = palette.fg, bg    = palette.none },
  WinBarNC = { fg = palette.grey1, bg = palette.none },
  -- stylua: ignore end

  -- stylua: ignore start
  VertSplit    = { fg = palette.bg5, bg = palette.none },
  WinSeparator = { fg = palette.bg5, bg = palette.none },
  -- stylua: ignore end

  -- stylua: ignore start
  Visual    = { fg = palette.none, bg = palette.bg3 },
  VisualNOS = { fg = palette.none, bg = palette.bg3 },
  -- stylua: ignore end

  QuickFixLine = { fg = palette.purple, bg = palette.none },

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
  Debug           = { fg = palette.orange, bg = palette.none },
  debugPC         = { fg = palette.bg0, bg    = palette.green },
  debugBreakpoint = { fg = palette.bg0, bg    = palette.red },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticError = { fg = palette.red,    bg = palette.none },
  DiagnosticHint  = { fg = palette.purple, bg = palette.none },
  DiagnosticInfo  = { fg = palette.blue,   bg = palette.none },
  DiagnosticOk    = { fg = palette.green,  bg = palette.none },
  DiagnosticWarn  = { fg = palette.yellow, bg = palette.none },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticUnderlineError = { fg = palette.red,    bg = palette.none, undercurl = true },
  DiagnosticUnderlineHint  = { fg = palette.purple, bg = palette.none, undercurl = true },
  DiagnosticUnderlineInfo  = { fg = palette.blue,   bg = palette.none, undercurl = true },
  DiagnosticUnderlineOk    = { fg = palette.green,  bg = palette.none, undercurl = true },
  DiagnosticUnderlineWarn  = { fg = palette.yellow, bg = palette.none, undercurl = true },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticFloatingError = { link = "ErrorFloat"   },
  DiagnosticFloatingHint  = { link = "HintFloat"    },
  DiagnosticFloatingInfo  = { link = "InfoFloat"    },
  DiagnosticFloatingOk    = { link = "OkFloat"      },
  DiagnosticFloatingWarn  = { link = "WarningFloat" },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticVirtualTextError = { link = "VirtualTextError"   },
  DiagnosticVirtualTextHint  = { link = "VirtualTextHint"    },
  DiagnosticVirtualTextInfo  = { link = "VirtualTextInfo"    },
  DiagnosticVirtualTextOk    = { link = "VirtualTextOk"      },
  DiagnosticVirtualTextWarn  = { link = "VirtualTextWarning" },
  -- stylua: ignore end

  -- stylua: ignore start
  DiagnosticSignError = { link = "Red" },
  DiagnosticSignHint  = { link = "Purple" },
  DiagnosticSignInfo  = { link = "Blue" },
  DiagnosticSignOk    = { link = "Green" },
  DiagnosticSignWarn  = { link = "Yellow" },
  -- stylua: ignore end

  DiagnosticUnnecessary = { fg = palette.grey1, bg = palette.none },
  DiagnosticDeprecated = { link = "Strikethrough" },

  -- stylua: ignore start
  LspDiagnosticsFloatingError          = { link = "DiagnosticFloatingError" },
  LspDiagnosticsFloatingWarning        = { link = "DiagnosticFloatingWarn" },
  LspDiagnosticsFloatingInformation    = { link = "DiagnosticFloatingInfo" },
  LspDiagnosticsFloatingHint           = { link = "DiagnosticFloatingHint" },

  LspDiagnosticsDefaultError           = { link = "DiagnosticError" },
  LspDiagnosticsDefaultWarning         = { link = "DiagnosticWarn" },
  LspDiagnosticsDefaultInformation     = { link = "DiagnosticInfo" },
  LspDiagnosticsDefaultHint            = { link = "DiagnosticHint" },

  LspDiagnosticsVirtualTextError       = { link = "DiagnosticVirtualTextError" },
  LspDiagnosticsVirtualTextWarning     = { link = "DiagnosticVirtualTextWarn" },
  LspDiagnosticsVirtualTextInformation = { link = "DiagnosticVirtualTextInfo" },
  LspDiagnosticsVirtualTextHint        = { link = "DiagnosticVirtualTextHint" },

  LspDiagnosticsUnderlineError         = { link = "DiagnosticUnderlineError" },
  LspDiagnosticsUnderlineWarning       = { link = "DiagnosticUnderlineWarn" },
  LspDiagnosticsUnderlineInformation   = { link = "DiagnosticUnderlineInfo" },
  LspDiagnosticsUnderlineHint          = { link = "DiagnosticUnderlineHint" },

  LspDiagnosticsSignError              = { link = "DiagnosticSignError" },
  LspDiagnosticsSignWarning            = { link = "DiagnosticSignWarn" },
  LspDiagnosticsSignInformation        = { link = "DiagnosticSignInfo" },
  LspDiagnosticsSignHint               = { link = "DiagnosticSignHint" },

  LspInlayHint                         = { link = "InlayHints" },

  LspReferenceText                     = { link = "CurrentWord" },
  LspReferenceRead                     = { link = "CurrentWord" },
  LspReferenceWrite                    = { link = "CurrentWord" },

  LspCodeLens                          = { link = "VirtualTextInfo" },
  LspCodeLensSeparator                 = { link = "VirtualTextHint" },

  LspSignatureActiveParameter          = { link = "Search" },
  -- stylua: ignore end

  -- stylua: ignore start
  healthError   = { link = "Red" },
  healthSuccess = { link = "Green" },
  healthWarning = { link = "Yellow" },
  -- stylua: ignore end

  -- INFO: Syntax Highlight Groups
  -- stylua: ignore start
  Boolean      = { fg = palette.purple, bg = palette.none },
  Define       = { fg = palette.purple, bg = palette.none },
  Float        = { fg = palette.purple, bg = palette.none },
  Include      = { fg = palette.purple, bg = palette.none },
  Number       = { fg = palette.purple, bg = palette.none },
  PreCondit    = { fg = palette.purple, bg = palette.none },
  PreProc      = { fg = palette.purple, bg = palette.none },
  Conditional  = { fg = palette.red,    bg = palette.none },
  Error        = { fg = palette.red,    bg = palette.none },
  Exception    = { fg = palette.red,    bg = palette.none },
  Keyword      = { fg = palette.red,    bg = palette.none },
  Repeat       = { fg = palette.red,    bg = palette.none },
  Statement    = { fg = palette.red,    bg = palette.none },
  Typedef      = { fg = palette.red,    bg = palette.none },
  Label        = { fg = palette.orange, bg = palette.none },
  Operator     = { fg = palette.orange, bg = palette.none },
  StorageClass = { fg = palette.orange, bg = palette.none },
  Structure    = { fg = palette.orange, bg = palette.none },
  Tag          = { fg = palette.orange, bg = palette.none },
  Title        = { fg = palette.orange, bg = palette.none },
  Special      = { fg = palette.yellow, bg = palette.none },
  SpecialChar  = { fg = palette.yellow, bg = palette.none },
  Type         = { fg = palette.yellow, bg = palette.none },
  Character    = { fg = palette.green,  bg = palette.none },
  Function     = { fg = palette.green,  bg = palette.none },
  Constant     = { fg = palette.aqua,   bg = palette.none },
  Macro        = { fg = palette.aqua,   bg = palette.none },
  String       = { fg = palette.aqua,   bg = palette.none },
  Identifier   = { fg = palette.blue,   bg = palette.none },
  Todo         = { fg = palette.blue,   bg = palette.none, reverse = true, bold = true },
  -- stylua: ignore end

  -- stylua: ignore start
  Comment        = { fg = palette.grey1, bg = palette.none, italic = true },
  SpecialComment = { fg = palette.grey1, bg = palette.none, italic = true },
  -- stylua: ignore end

  -- stylua: ignore start
  Delimiter  = { fg = palette.fg, bg    = palette.none },
  Ignore     = { fg = palette.grey1, bg = palette.none },
  Underlined = { fg = palette.none, bg  = palette.none, underline = true },
  -- stylua: ignore end

  -- INFO: Predefined Highlight Groups
  -- stylua: ignore start
  Fg     = { fg = palette.fg,     bg = palette.none },
  Grey   = { fg = palette.grey1,  bg = palette.none },
  White  = { fg = palette.white,  bg = palette.none },
  Red    = { fg = palette.red,    bg = palette.none },
  Orange = { fg = palette.orange, bg = palette.none },
  Yellow = { fg = palette.yellow, bg = palette.none },
  Green  = { fg = palette.green,  bg = palette.none },
  Aqua   = { fg = palette.aqua,   bg = palette.none },
  Blue   = { fg = palette.blue,   bg = palette.none },
  Purple = { fg = palette.purple, bg = palette.none },
  -- stylua: ignore end

  -- stylua: ignore start
  Bold          = { fg = palette.none, bg = palette.none, bold          = true },
  Italic        = { fg = palette.none, bg = palette.none, italic        = true },
  Underline     = { fg = palette.none, bg = palette.none, underline     = true },
  Strikethrough = { fg = palette.none, bg = palette.none, strikethrough = true },
  -- stylua: ignore end

  -- stylua: ignore start
  BgRed    = { bg = palette.bg_red    },
  BgOrange = { bg = palette.bg_orange },
  BgYellow = { bg = palette.bg_yellow },
  BgGreen  = { bg = palette.bg_green  },
  BgBlue   = { bg = palette.bg_blue   },
  BgPurple = { bg = palette.bg_purple },
  -- stylua: ignore end

  -- stylua: ignore start
  Added   = { link = "Green" },
  Removed = { link = "Red"   },
  Changed = { link = "Blue"  },
  -- stylua: ignore end

  -- stylua: ignore start
  ErrorText   = { fg = palette.none, bg = palette.bg_red,    undercurl = true },
  HintText    = { fg = palette.none, bg = palette.bg_purple, undercurl = true },
  InfoText    = { fg = palette.none, bg = palette.bg_blue,   undercurl = true },
  WarningText = { fg = palette.none, bg = palette.bg_yellow, undercurl = true },
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

  CurrentWord  = { fg = palette.none, bg = palette.none, underline = true },

  InlayHints = { fg = palette.grey0, bg = palette.bg_dim },
  -- stylua: ignore end


  -- INFO: Treesitter Highlight Groups
  -- stylua: ignore start
  TSStrong    = { link = "Bold"          },
  TSEmphasis  = { link = "Italic"        },
  TSUnderline = { link = "Underline"     },
  TSStrike    = { link = "Strikethrough" },

  TSNote    = { fg = palette.bg0,  bg = palette.green,  bold      = true },
  TSWarning = { fg = palette.bg0,  bg = palette.yellow, bold      = true },
  TSDanger  = { fg = palette.bg0,  bg = palette.red,    bold      = true },
  TSTodo    = { fg = palette.bg0,  bg = palette.blue,   bold      = true },
  TSURI     = { fg = palette.blue, bg = palette.none,   underline = true },

  TSAnnotation           = { link = "Purple"      },
  TSAttribute            = { link = "Purple"      },
  TSBoolean              = { link = "Purple"      },
  TSCharacter            = { link = "Aqua"        },
  TSCharacterSpecial     = { link = "SpecialChar" },
  TSComment              = { link = "Comment"     },
  TSConditional          = { link = "Red"         },
  TSConstBuiltin         = { link = "Purple"      },
  TSConstMacro           = { link = "Purple"      },
  TSConstant             = { link = "Constant"    },
  TSConstructor          = { link = "Green"       },
  TSDebug                = { link = "Debug"       },
  TSDefine               = { link = "Define"      },
  TSEnvironment          = { link = "Macro"       },
  TSEnvironmentName      = { link = "Type"        },
  TSError                = { link = "Error"       },
  TSException            = { link = "Red"         },
  TSField                = { link = "Blue"        },
  TSFloat                = { link = "Purple"      },
  TSFuncBuiltin          = { link = "Green"       },
  TSFuncMacro            = { link = "Green"       },
  TSFunction             = { link = "Green"       },
  TSFunctionCall         = { link = "Green"       },
  TSInclude              = { link = "Red"         },
  TSKeyword              = { link = "Red"         },
  TSKeywordFunction      = { link = "Red"         },
  TSKeywordOperator      = { link = "Orange"      },
  TSKeywordReturn        = { link = "Red"         },
  TSLabel                = { link = "Orange"      },
  TSLiteral              = { link = "String"      },
  TSMath                 = { link = "Blue"        },
  TSMethod               = { link = "Green"       },
  TSMethodCall           = { link = "Green"       },
  TSModuleInfoGood       = { link = "Green"       },
  TSModuleInfoBad        = { link = "Red"         },
  TSNamespace            = { link = "Yellow"      },
  TSNone                 = { link = "Fg"          },
  TSNumber               = { link = "Purple"      },
  TSOperator             = { link = "Orange"      },
  TSParameter            = { link = "Fg"          },
  TSParameterReference   = { link = "Fg"          },
  TSPreProc              = { link = "PreProc"     },
  TSProperty             = { link = "Blue"        },
  TSPunctBracket         = { link = "Fg"          },
  TSPunctDelimiter       = { link = "Grey"        },
  TSPunctSpecial         = { link = "Blue"        },
  TSRepeat               = { link = "Red"         },
  TSStorageClass         = { link = "Orange"      },
  TSStorageClassLifetime = { link = "Orange"      },
  TSString               = { link = "Aqua"        },
  TSStringEscape         = { link = "Green"       },
  TSStringRegex          = { link = "Green"       },
  TSStringSpecial        = { link = "SpecialChar" },
  TSSymbol               = { link = "Fg"          },
  TSTag                  = { link = "Orange"      },
  TSTagAttribute         = { link = "Green"       },
  TSTagDelimiter         = { link = "Green"       },
  TSText                 = { link = "Green"       },
  TSTextReference        = { link = "Constant"    },
  TSTitle                = { link = "Title"       },
  TSType                 = { link = "Yellow"      },
  TSTypeBuiltin          = { link = "Yellow"      },
  TSTypeDefinition       = { link = "Yellow"      },
  TSTypeQualifier        = { link = "Orange"      },
  TSVariable             = { link = "Green"       },
  TSVariableBuiltin      = { link = "Purple"      },
  -- stylua: ignore end

  -- stylua: ignore start
  ["@annotation"]               = { link = "TSAnnotation"           },
  ["@attribute"]                = { link = "TSAttribute"            },
  ["@boolean"]                  = { link = "TSBoolean"              },
  ["@character"]                = { link = "TSCharacter"            },
  ["@character.special"]        = { link = "TSCharacterSpecial"     },
  ["@comment"]                  = { link = "TSComment"              },
  ["@comment.error"]            = { link = "TSDanger"               },
  ["@comment.note"]             = { link = "TSNote"                 },
  ["@comment.todo"]             = { link = "TSTodo"                 },
  ["@comment.warning"]          = { link = "TSWarning"              },
  ["@conceal"]                  = { link = "Grey"                   },
  ["@conditional"]              = { link = "TSConditional"          },
  ["@constant"]                 = { link = "TSConstant"             },
  ["@constant.builtin"]         = { link = "TSConstBuiltin"         },
  ["@constant.macro"]           = { link = "TSConstMacro"           },
  ["@constant.regex"]           = { link = "TSConstBuiltin"         },
  ["@constructor"]              = { link = "TSConstructor"          },
  ["@debug"]                    = { link = "TSDebug"                },
  ["@define"]                   = { link = "TSDefine"               },
  ["@diff.delta"]               = { link = "diffChanged"            },
  ["@diff.minus"]               = { link = "diffRemoved"            },
  ["@diff.plus"]                = { link = "diffAdded"              },
  ["@error"]                    = { link = "TSError"                }, -- This has been removed from nvim-treesitter
  ["@exception"]                = { link = "TSException"            },
  ["@field"]                    = { link = "TSField"                },
  ["@float"]                    = { link = "TSFloat"                },
  ["@function"]                 = { link = "TSFunction"             },
  ["@function.builtin"]         = { link = "TSFuncBuiltin"          },
  ["@function.call"]            = { link = "TSFunctionCall"         },
  ["@function.macro"]           = { link = "TSFuncMacro"            },
  ["@function.method"]          = { link = "TSMethod"               },
  ["@function.method.call"]     = { link = "TSMethodCall"           },
  ["@include"]                  = { link = "TSInclude"              },
  ["@keyword"]                  = { link = "TSKeyword"              },
  ["@keyword.conditional"]      = { link = "TSConditional"          },
  ["@keyword.debug"]            = { link = "TSDebug"                },
  ["@keyword.directive"]        = { link = "TSPreProc"              },
  ["@keyword.directive.define"] = { link = "TSDefine"               },
  ["@keyword.exception"]        = { link = "TSException"            },
  ["@keyword.function"]         = { link = "TSKeywordFunction"      },
  ["@keyword.import"]           = { link = "TSInclude"              },
  ["@keyword.modifier"]         = { link = "TSTypeQualifier"        },
  ["@keyword.operator"]         = { link = "TSKeywordOperator"      },
  ["@keyword.repeat"]           = { link = "TSRepeat"               },
  ["@keyword.return"]           = { link = "TSKeywordReturn"        },
  ["@keyword.storage"]          = { link = "TSStorageClass"         },
  ["@label"]                    = { link = "TSLabel"                },
  ["@markup.emphasis"]          = { link = "TSEmphasis"             },
  ["@markup.environment"]       = { link = "TSEnvironment"          },
  ["@markup.environment.name"]  = { link = "TSEnvironmentName"      },
  ["@markup.heading"]           = { link = "TSTitle"                },
  ["@markup.link"]              = { link = "TSTextReference"        },
  ["@markup.link.label"]        = { link = "TSStringSpecial"        },
  ["@markup.link.url"]          = { link = "TSURI"                  },
  ["@markup.list"]              = { link = "TSPunctSpecial"         },
  ["@markup.list.checked"]      = { link = "Green"                  },
  ["@markup.list.unchecked"]    = { link = "Ignore"                 },
  ["@markup.math"]              = { link = "TSMath"                 },
  ["@markup.note"]              = { link = "TSNote"                 },
  ["@markup.quote"]             = { link = "Grey"                   },
  ["@markup.raw"]               = { link = "TSLiteral"              },
  ["@markup.strike"]            = { link = "TSStrike"               },
  ["@markup.strong"]            = { link = "TSStrong"               },
  ["@markup.underline"]         = { link = "TSUnderline"            },
  ["@markup.italic"]            = { link = "TSEmphasis"             }, -- NOTE: nvim-0.8
  ["@math"]                     = { link = "TSMath"                 },
  ["@method"]                   = { link = "TSMethod"               },
  ["@method.call"]              = { link = "TSMethodCall"           },
  ["@module"]                   = { link = "TSNamespace"            },
  ["@namespace"]                = { link = "TSNamespace"            },
  ["@none"]                     = { link = "TSNone"                 },
  ["@number"]                   = { link = "TSNumber"               },
  ["@number.float"]             = { link = "TSFloat"                },
  ["@operator"]                 = { link = "TSOperator"             },
  ["@parameter"]                = { link = "TSParameter"            },
  ["@parameter.reference"]      = { link = "TSParameterReference"   },
  ["@preproc"]                  = { link = "TSPreProc"              },
  ["@property"]                 = { link = "TSProperty"             },
  ["@punctuation.bracket"]      = { link = "TSPunctBracket"         },
  ["@punctuation.delimiter"]    = { link = "TSPunctDelimiter"       },
  ["@punctuation.special"]      = { link = "TSPunctSpecial"         },
  ["@repeat"]                   = { link = "TSRepeat"               },
  ["@storageclass"]             = { link = "TSStorageClass"         },
  ["@storageclass.lifetime"]    = { link = "TSStorageClassLifetime" },
  ["@strike"]                   = { link = "TSStrike"               },
  ["@string"]                   = { link = "TSString"               },
  ["@string.escape"]            = { link = "TSStringEscape"         },
  ["@string.regex"]             = { link = "TSStringRegex"          },
  ["@string.regexp"]            = { link = "TSStringRegex"          },
  ["@string.special"]           = { link = "TSStringSpecial"        },
  ["@string.special.symbol"]    = { link = "TSSymbol"               },
  ["@string.special.url"]       = { link = "TSURI"                  },
  ["@symbol"]                   = { link = "TSSymbol"               },
  ["@tag"]                      = { link = "TSTag"                  },
  ["@tag.attribute"]            = { link = "TSTagAttribute"         },
  ["@tag.delimiter"]            = { link = "TSTagDelimiter"         },
  ["@text"]                     = { link = "TSText"                 },
  ["@text.danger"]              = { link = "TSDanger"               },
  ["@text.diff.add"]            = { link = "diffAdded"              },
  ["@text.diff.delete"]         = { link = "diffRemoved"            },
  ["@text.emphasis"]            = { link = "TSEmphasis"             },
  ["@text.environment"]         = { link = "TSEnvironment"          },
  ["@text.environment.name"]    = { link = "TSEnvironmentName"      },
  ["@text.literal"]             = { link = "TSLiteral"              },
  ["@text.gitcommit"]           = { link = "TSNone"                 },
  ["@text.math"]                = { link = "TSMath"                 },
  ["@text.note"]                = { link = "TSNote"                 },
  ["@text.reference"]           = { link = "TSTextReference"        },
  ["@text.strike"]              = { link = "TSStrike"               },
  ["@text.strong"]              = { link = "TSStrong"               },
  ["@text.title"]               = { link = "TSTitle"                },
  ["@text.todo"]                = { link = "TSTodo"                 },
  ["@text.todo.checked"]        = { link = "Green"                  },
  ["@text.todo.unchecked"]      = { link = "Ignore"                 },
  ["@text.underline"]           = { link = "TSUnderline"            },
  ["@text.uri"]                 = { link = "TSURI"                  },
  ["@text.warning"]             = { link = "TSWarning"              },
  ["@todo"]                     = { link = "TSTodo"                 },
  ["@type"]                     = { link = "TSType"                 },
  ["@type.builtin"]             = { link = "TSTypeBuiltin"          },
  ["@type.definition"]          = { link = "TSTypeDefinition"       },
  ["@type.qualifier"]           = { link = "TSTypeQualifier"        },
  ["@uri"]                      = { link = "TSURI"                  },
  ["@variable"]                 = { link = "TSVariable"             },
  ["@variable.builtin"]         = { link = "TSVariableBuiltin"      },
  ["@variable.member"]          = { link = "TSField"                },
  ["@variable.parameter"]       = { link = "TSParameter"            },
  -- stylua: ignore end

  -- INFO: LSP Highlight Groups
  -- stylua: ignore start
  ["@lsp.type.class"]         = { link = "TSType"           },
  ["@lsp.type.comment"]       = { link = "TSComment"        },
  ["@lsp.type.decorator"]     = { link = "TSFunction"       },
  ["@lsp.type.enum"]          = { link = "TSType"           },
  ["@lsp.type.enumMember"]    = { link = "TSProperty"       },
  ["@lsp.type.function"]      = { link = "TSFunction"       },
  ["@lsp.type.interface"]     = { link = "TSType"           },
  ["@lsp.type.keyword"]       = { link = "TSKeyword"        },
  ["@lsp.type.macro"]         = { link = "TSConstMacro"     },
  ["@lsp.type.method"]        = { link = "TSMethod"         },
  ["@lsp.type.modifier"]      = { link = "TSTypeQualifier"  },
  ["@lsp.type.namespace"]     = { link = "TSNamespace"      },
  ["@lsp.type.number"]        = { link = "TSNumber"         },
  ["@lsp.type.operator"]      = { link = "TSOperator"       },
  ["@lsp.type.parameter"]     = { link = "TSParameter"      },
  ["@lsp.type.property"]      = { link = "TSProperty"       },
  ["@lsp.type.regexp"]        = { link = "TSStringRegex"    },
  ["@lsp.type.string"]        = { link = "TSString"         },
  ["@lsp.type.struct"]        = { link = "TSType"           },
  ["@lsp.type.type"]          = { link = "TSType"           },
  ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
  ["@lsp.type.variable"]      = { link = "TSVariable"       },
  -- stylua: ignore end

  -- INFO: Plugin Highlight Groups
  -- stylua: ignore start
  diffAdded     = { link = "Added"   },
  diffRemoved   = { link = "Removed" },
  diffChanged   = { link = "Changed" },
  diffOldFile   = { link = "Yellow"  },
  diffNewFile   = { link = "Orange"  },
  diffFile      = { link = "Aqua"    },
  diffLine      = { link = "Grey"    },
  diffIndexLine = { link = "Purple"  },
  -- stylua: ignore end

  -- INFO: HiPhish/rainbow-delimiters
  -- stylua: ignore start
  RainbowDelimiterRed    = { link = "Red"    },
  RainbowDelimiterOrange = { link = "Orange" },
  RainbowDelimiterYellow = { link = "Yellow" },
  RainbowDelimiterGreen  = { link = "Green"  },
  RainbowDelimiterCyan   = { link = "Aqua"   },
  RainbowDelimiterBlue   = { link = "Blue"   },
  RainbowDelimiterViolet = { link = "Purple" },
  -- stylua: ignore end

  -- INFO: SmiteshP/nvim-navic
  -- stylua: ignore start
  NavicIconsFile          = { link = "Fg"     },
  NavicIconsModule        = { link = "Yellow" },
  NavicIconsNamespace     = { link = "Fg"     },
  NavicIconsPackage       = { link = "Fg"     },
  NavicIconsClass         = { link = "Orange" },
  NavicIconsMethod        = { link = "Blue"   },
  NavicIconsProperty      = { link = "Green"  },
  NavicIconsField         = { link = "Green"  },
  NavicIconsConstructor   = { link = "Orange" },
  NavicIconsEnum          = { link = "Orange" },
  NavicIconsInterface     = { link = "Orange" },
  NavicIconsFunction      = { link = "Blue"   },
  NavicIconsVariable      = { link = "Purple" },
  NavicIconsConstant      = { link = "Purple" },
  NavicIconsString        = { link = "Green"  },
  NavicIconsNumber        = { link = "Orange" },
  NavicIconsBoolean       = { link = "Orange" },
  NavicIconsArray         = { link = "Orange" },
  NavicIconsObject        = { link = "Orange" },
  NavicIconsKey           = { link = "Purple" },
  NavicIconsKeyword       = { link = "Purple" },
  NavicIconsNull          = { link = "Orange" },
  NavicIconsEnumMember    = { link = "Green"  },
  NavicIconsStruct        = { link = "Orange" },
  NavicIconsEvent         = { link = "Orange" },
  NavicIconsOperator      = { link = "Fg"     },
  NavicIconsTypeParameter = { link = "Green"  },
  NavicText               = { link = "Fg"     },
  NavicSeparator          = { link = "Grey"   },
  -- stylua: ignore end

  -- INFO: https://github.com/nvim-mini/mini.nvim
  MiniAnimateCursor = { reverse = true, nocombine = true },
  MiniAnimateNormalFloat = { link = "NormalFloat" },

  -- stylua: ignore start
  MiniClueBorder              = { link = "FloatBorder"             },
  MiniClueDescGroup           = { link = "DiagnosticFloatingWarn"  },
  MiniClueDescSingle          = { link = "NormalFloat"             },
  MiniClueNextKey             = { link = "DiagnosticFloatingHint"  },
  MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
  MiniClueSeparator           = { link = "DiagnosticFloatingInfo"  },
  MiniClueTitle               = { link = "FloatTitle"              },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCmdlinePeekBorder = { link = "FloatBorder"        },
  MiniCmdlinePeekLineNr = { link = "DiagnosticSignWarn" },
  MiniCmdlinePeekNormal = { link = "NormalFloat"        },
  MiniCmdlinePeekSep    = { link = "SignColumn"         },
  MiniCmdlinePeekSign   = { link = "DiagnosticSignHint" },
  MiniCmdlinePeekTitle  = { link = "FloatTitle"         },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCompletionActiveParameter    = { link = "LspSignatureActiveParameter" },
  MiniCompletionDeprecated         = { link = "DiagnosticDeprecated"        },
  MiniCompletionInfoBorderOutdated = { link = "DiagnosticFloatingWarn"      },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniCursorword        = { link = "Underline" },
  MiniCursorwordCurrent = { link = "Underline" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniDepsChangeAdded   = { link = "Added"          },
  MiniDepsChangeRemoved = { link = "Removed"        },
  MiniDepsHints         = { link = "DiagnosticHint" },
  MiniDepsInfo          = { link = "DiagnosticInfo" },
  MiniDepsMsgBreaking   = { link = "DiagnosticWarn" },
  MiniDepsPlaceholder   = { link = "Comment"        },
  MiniDepsTitle         = { link = "Title"          },
  MiniDepsTitleError    = { link = "DiffDelete"     },
  MiniDepsTitleSame     = { link = "DiffChange"     },
  MiniDepsTitleUpdate   = { link = "DiffAdd"        },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniDiffOverAdd     = { link = "DiffAdd"    },
  MiniDiffOverChange  = { link = "DiffText"   },
  MiniDiffOverContext = { link = "DiffChange" },
  MiniDiffOverDelete  = { link = "DiffDelete" },
  MiniDiffSignAdd     = { link = "Added"      },
  MiniDiffSignChange  = { link = "Changed"    },
  MiniDiffSignDelete  = { link = "Removed"    },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniFilesBorder         = { link = "FloatBorder"            },
  MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
  MiniFilesCursorLine     = { link = "CursorLine"             },
  MiniFilesDirectory      = { link = "Directory"              },
  MiniFilesFile           = { link = "NormalFloat"            },
  MiniFilesNormal         = { link = "NormalFloat"            },
  MiniFilesTitle          = { link = "FloatTitle"             },
  MiniFilesTitleFocused   = { link = "FloatTitleFocused"      },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniIconsAzure   = { link = "Blue"   },
  MiniIconsBlue    = { link = "Blue"   },
  MiniIconsCyan    = { link = "Aqua"   },
  MiniIconsGreen   = { link = "Green"  },
  MiniIconsGrey    = { link = "Grey"   },
  MiniIconsOrange  = { link = "Orange" },
  MiniIconsMagenta = { link = "Purple" },
  MiniIconsRed     = { link = "Red"    },
  MiniIconsYellow  = { link = "Yellow" },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniIndentscopeSymbol    = { link = "White" },
  MiniIndentscopeSymbolOff = { link = "Red"   },
  -- stylua: ignore end

  MiniJump = { link = "SpellRare" },

  -- stylua: ignore start
  MiniJump2dDim        = { link = "Comment" },
  MiniJump2dSpot       = { link = "Orange"  },
  MiniJump2dSpotAhead  = { link = "Aqua"    },
  MiniJump2dSpotUnique = { link = "Yellow"  },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniMapNormal      = { link = "NormalFloat" },
  MiniMapSymbolCount = { link = "Special"     },
  MiniMapSymbolLine  = { link = "Title"       },
  MiniMapSymbolView  = { link = "Delimiter"   },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniNotifyBorder      = { link = "FloatBorder" },
  MiniNotifyNormal      = { link = "NormalFloat" },
  MiniNotifyTitle       = { link = "FloatTitle"  },
  MiniNotifyLspProgress = { fg   = palette.blue, bg = palette.none, italic = true },
  -- stylua: ignore end

  MiniOperatorsExchangeFrom = { link = "IncSearch" },

  -- stylua: ignore start
  MiniSnippetsCurrent        = { link = "DiagnosticUnderlineWarn"  },
  MiniSnippetsCurrentReplace = { link = "DiagnosticUnderlineError" },
  MiniSnippetsFinal          = { link = "DiagnosticUnderlineOk"    },
  MiniSnippetsUnvisited      = { link = "DiagnosticUnderlineHint"  },
  MiniSnippetsVisited        = { link = "DiagnosticUnderlineInfo"  },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniStarterCurrent    = { link = "MiniStarterItem" },
  MiniStarterFooter     = { link = "Blue"            },
  MiniStarterHeader     = { link = "Yellow"          },
  MiniStarterInactive   = { link = "Comment"         },
  MiniStarterItem       = { link = "Normal"          },
  MiniStarterItemBullet = { link = "Grey"            },
  MiniStarterItemPrefix = { link = "Yellow"          },
  MiniStarterQuery      = { link = "Blue"            },
  MiniStarterSection    = { link = "Title"           },
  -- stylua: ignore end

  -- stylua: ignore start
  -- NOTE: Modes highlight groups
  MiniStatuslineModeCommand = { fg = palette.bg0, bg = palette.aqua   },
  MiniStatuslineModeInsert  = { fg = palette.bg0, bg = palette.fg     },
  MiniStatuslineModeNormal  = { fg = palette.bg0, bg = palette.green  },
  MiniStatuslineModeOther   = { fg = palette.bg0, bg = palette.purple },
  MiniStatuslineModeReplace = { fg = palette.bg0, bg = palette.orange },
  MiniStatuslineModeVisual  = { fg = palette.bg0, bg = palette.red    },

  MiniStatuslineDevinfo     = { fg = palette.grey2,  bg = palette.bg1 },
  MiniStatuslineFilename    = { fg = palette.grey1,  bg = palette.bg2 },
  MiniStatuslineFileinfo    = { fg = palette.grey2,  bg = palette.bg2 },
  MiniStatuslineLocation    = { fg = palette.grey2,  bg = palette.bg1 },
  MiniStatuslineInactive    = { fg = palette.grey2,  bg = palette.bg1 },

  -- NOTE: Colored Diagnostics (Custom. Bg needs to match StatuslineDevinfo)
  MiniStatuslineDiagError   = { fg = palette.red,    bg = palette.bg1 },
  MiniStatuslineDiagWarn    = { fg = palette.yellow, bg = palette.bg1 },
  MiniStatuslineDiagInfo    = { fg = palette.purple, bg = palette.bg1 },
  MiniStatuslineDiagHint    = { fg = palette.blue,   bg = palette.bg1 },
  -- NOTE: Colored Diff (Custom. Bg needs to match StatuslineDevinfo)
  MiniStatuslineDiffAdd     = { link = "Green" },
  MiniStatuslineDiffChange  = { link = "Blue" },
  MiniStatuslineDiffDelete  = { link = "Red" },
  -- stylua: ignore end

  MiniSurround = { link = "IncSearch" },

  -- stylua: ignore start
  MiniTablineCurrent         = { link = "TabLineSel"  },
  MiniTablineHidden          = { link = "TabLine"     },
  MiniTablineFill            = { link = "TabLineFill" },
  MiniTablineModifiedCurrent = { link = "TabLineSel"  },
  MiniTablineModifiedHidden  = { link = "TabLine"     },
  MiniTablineModifiedVisible = { link = "TabLine"     },
  MiniTablineTabpagesection  = { link = "TabLineFill" },
  MiniTablineVisible         = { link = "TabLine"     },
  -- stylua: ignore end

  -- stylua: ignore start
  MiniTestEmphasis = { link = "Bold"  },
  MiniTestFail     = { link = "Red"   },
  MiniTestPass     = { link = "Green" },
  -- stylua: ignore end

  MiniTrailspace = { fg = palette.none, bg = palette.red },

  -- stylua: ignore start
  MiniPickBorder        = { link = "FloatBorder"            },
  MiniPickBorderBusy    = { link = "DiagnosticFloatingWarn" },
  MiniPickBorderText    = { link = "FloatTitle"             },
  MiniPickCursor        = { blend = 100, nocombine = true   },
  MiniPickIconDirectory = { link = "Directory"              },
  MiniPickIconFile      = { link = "MiniPickNormal"         },
  MiniPickHeader        = { link = "DiagnosticFloatingHint" },
  MiniPickMatchCurrent  = { link = "CursorLine"             },
  MiniPickMatchMarked   = { link = "Visual"                 },
  MiniPickMatchRanges   = { link = "DiagnosticFloatingHint" },
  MiniPickNormal        = { link = "NormalFloat"            },
  MiniPickPreviewLine   = { link = "CursorLine"             },
  MiniPickPreviewRegion = { link = "IncSearch"              },
  MiniPickPrompt        = { link = "DiagnosticFloatingInfo" },
  MiniPickPromptCaret   = { link = "MiniPickPrompt"         },
  MiniPickPromptPrefix  = { link = "MiniPickPrompt"         },
  -- stylua: ignore end

  -- williamboman/mason.nvim
  MasonHeader                      = { fg = palette.green,  bg = palette.bg0, reverse = true   },
  MasonHeaderSecondary             = { fg = palette.orange, bg = palette.bg0, reverse = true   },
  MasonHighlight                   = { fg = palette.green,  bg = palette.none                  },
  MasonHighlightSecondary          = { fg  = palette.green, bg = palette.none                  },
  MasonHighlightBlock              = { fg = palette.aqua,   bg = palette.bg0, reverse = true   },
  MasonHighlightBlockBold          = { fg = palette.aqua,   bg = palette.bg0, reverse = true   },
  MasonHighlightBlockSecondary     = { fg = palette.yellow, bg = palette.bg0, reverse = true   },
  MasonHighlightBlockBoldSecondary = { fg = palette.yellow, bg = palette.bg0, reverse = true   },
  MasonMuted                       = { fg = palette.grey0,  bg = palette.none                  },
  MasonMutedBlock                  = { fg = palette.bg0,    bg = palette.grey0                 },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
