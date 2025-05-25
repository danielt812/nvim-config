local M = { "echasnovski/mini.icons" }

M.enabled = true

M.event = { "VeryLazy" }

M.init = function()
  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end
end

M.opts = function()
  local test_icon = ""
  -- stylua: ignore start
  local js_table  = { glyph = test_icon, hl = "MiniIconsYellow" }
  local jsx_table = { glyph = test_icon, hl = "MiniIconsAzure" }
  local ts_table  = { glyph = test_icon, hl = "MiniIconsAzure" }
  local tsx_table = { glyph = test_icon, hl = "MiniIconsBlue" }
  -- stylua: ignore end
  return {
    style = "glyph",
    default = {},
    directory = {
      -- stylua: ignore start
      [".git"]     = { glyph = "󰊢", hl = "MiniIconsOrange" },
      [".github"]  = { glyph = "󰊤", hl = "MiniIconsAzure" },
      ["config"]   = { glyph = "󱁿", hl = "MiniIconsAzure" },
      ["settings"] = { glyph = "󱁿", hl = "MiniIconsAzure" },
      ["icons"]    = { glyph = "󱞊", hl = "MiniIconsAzure" },
      ["utils"]    = { glyph = "󱧼", hl = "MiniIconsAzure" },
      ["colors"]   = { glyph = "󱁽", hl = "MiniIconsAzure" },
      -- stylua: ignore end
    },
    extension = {
      ["test.js"] = js_table,
      ["test.jsx"] = jsx_table,
      ["test.ts"] = ts_table,
      ["test.tsx"] = tsx_table,
      ["spec.js"] = js_table,
      ["spec.jsx"] = jsx_table,
      ["spec.ts"] = ts_table,
      ["spec.tsx"] = tsx_table,
    },
    file = {
      ["README"] = { glyph = "󰈙", hl = "MiniIconsYellow" },
      ["README.md"] = { glyph = "󰈙", hl = "MiniIconsYellow" },
      [".dockerignore"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
    },
    filetype = {},
    lsp = {
      ["copilot"] = { glyph = "", hl = "MiniIconsOrange" },
      ["snippet"] = { glyph = "", hl = "MiniIconsGreen" },
    },
    os = {},
  }
end

M.config = function(_, opts)
  local icons = require("mini.icons")

  icons.mock_nvim_web_devicons()
  icons.tweak_lsp_kind()

  icons.setup(opts)
end

return M
