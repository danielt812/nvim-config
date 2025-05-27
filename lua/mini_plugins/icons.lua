local icons = require("mini.icons")

-- stylua: ignore start

local test_icon = ""
local js_table  = { glyph = test_icon, hl = "MiniIconsYellow" }
local jsx_table = { glyph = test_icon, hl = "MiniIconsAzure" }
local ts_table  = { glyph = test_icon, hl = "MiniIconsAzure" }
local tsx_table = { glyph = test_icon, hl = "MiniIconsBlue" }

icons.setup({
  directory = {
    [".git"]     = { glyph = "󰊢", hl = "MiniIconsOrange" },
    [".github"]  = { glyph = "󰊤", hl = "MiniIconsAzure" },
    ["config"]   = { glyph = "󱁿", hl = "MiniIconsAzure" },
    ["settings"] = { glyph = "󱁿", hl = "MiniIconsAzure" },
    ["icons"]    = { glyph = "󱞊", hl = "MiniIconsAzure" },
    ["utils"]    = { glyph = "󱧼", hl = "MiniIconsAzure" },
    ["colors"]   = { glyph = "󱁽", hl = "MiniIconsAzure" },
  },
  extension = {
    ["test.js"]  = js_table,
    ["test.jsx"] = jsx_table,
    ["test.ts"]  = ts_table,
    ["test.tsx"] = tsx_table,
    ["spec.js"]  = js_table,
    ["spec.jsx"] = jsx_table,
    ["spec.ts"]  = ts_table,
    ["spec.tsx"] = tsx_table,
  },
  file = {
    ["README"]        = { glyph = "󰈙", hl = "MiniIconsYellow" },
    ["README.md"]     = { glyph = "󰈙", hl = "MiniIconsYellow" },
    [".dockerignore"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
  },
  filetype = {},
  lsp = {
    ["copilot"] = { glyph = "", hl = "MiniIconsOrange" },
    ["snippet"] = { glyph = "", hl = "MiniIconsGreen" },
  },
  os = {},
})

-- stylua: ignore end

icons.mock_nvim_web_devicons()
icons.tweak_lsp_kind()
