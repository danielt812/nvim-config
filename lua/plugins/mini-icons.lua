local M = { "echasnovski/mini.icons" }

M.enabled = true

M.event = { "VimEnter" }

M.init = function()
  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end
end

M.opts = function()
  local test_icon = ""
  local js_table = { glyph = test_icon, hl = "MiniIconsYellow" }
  local jsx_table = { glyph = test_icon, hl = "MiniIconsAzure" }
  local ts_table = { glyph = test_icon, hl = "MiniIconsAzure" }
  local tsx_table = { glyph = test_icon, hl = "MiniIconsBlue" }
  return {
    -- Icon style: 'glyph' or 'ascii'
    style = "glyph",

    -- Customize per category. See `:h MiniIcons.config` for details.
    default = {},
    directory = {
      [".git"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
      [".github"] = { glyph = "󰊤", hl = "MiniIconsAzure" },
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
    },
    filetype = {},
    lsp = {
      ["copilot"] = { glyph = "", hl = "MiniIconsGrey" },
      ["snippet"] = { glyph = "", hl = "MiniIconsGreen" },
    },
    os = {},
  }
end

M.config = function(_, opts)
  require("mini.icons").setup(opts)
end

return M
