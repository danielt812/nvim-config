local icons = require("mini.icons")

-- stylua: ignore start
local test_icon = ""
local js_table  = { glyph = test_icon, hl = "MiniIconsYellow" }
local ts_table  = { glyph = test_icon, hl = "MiniIconsAzure" }
-- stylua: ignore end

icons.setup({
  directory = {
    -- stylua: ignore start
    [".git"]         = { glyph = "󰊢", hl = "MiniIconsOrange" },
    [".github"]      = { glyph = "󰊤", hl = "MiniIconsAzure" },
    ["colors"]       = { glyph = "󱁽", hl = "MiniIconsAzure" },
    ["config"]       = { glyph = "󱁿", hl = "MiniIconsAzure" },
    ["assets"]       = { glyph = "󰉏", hl = "MiniIconsAzure" },
    ["icons"]        = { glyph = "󰉏", hl = "MiniIconsAzure" },
    ["images"]       = { glyph = "󰉏", hl = "MiniIconsAzure" },
    ["lsp"]          = { glyph = "󱁽", hl = "MiniIconsAzure" },
    ["schemas"]      = { glyph = "󱁿", hl = "MiniIconsAzure" },
    ["settings"]     = { glyph = "󱁿", hl = "MiniIconsAzure" },
    ["utils"]        = { glyph = "󱧼", hl = "MiniIconsAzure" },
    ["recipes"]      = { glyph = "󰭼", hl = "MiniIconsYellow" },
    ["mini_plugins"] = { glyph = "󰚝", hl = "MiniIconsAzure" },
    ["modules"]      = { glyph = "󰚝", hl = "MiniIconsAzure" },
    ["plugins"]      = { glyph = "󰚝", hl = "MiniIconsAzure" },
    -- stylua: ignore end
  },
  extension = {
    -- stylua: ignore start
    ["test.js"]  = js_table,
    ["test.jsx"] = js_table,
    ["test.ts"]  = ts_table,
    ["test.tsx"] = ts_table,
    ["spec.js"]  = js_table,
    ["spec.jsx"] = js_table,
    ["spec.ts"]  = ts_table,
    ["spec.tsx"] = ts_table,
    ["env"]      = { glyph = "󰒓", hl = "MiniIconsGrey" },
    -- stylua: ignore end
  },
  file = {
    -- stylua: ignore start
    ["README"]        = { glyph = "󰈙", hl = "MiniIconsYellow" },
    ["README.md"]     = { glyph = "󰈙", hl = "MiniIconsYellow" },
    [".dockerignore"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
    [".gitignore"]    = { glyph = "󰊢", hl = "MiniIconsOrange" },
    [".shellcheckrc"] = { glyph = "󰒓", hl = "MiniIconsGrey" },
    -- stylua: ignore end
  },
  filetype = {
    -- stylua: ignore start
    ["dap-view"]       = { glyph = "", hl = "MiniIconsRed" },
    ["ghostty"]        = { glyph = "󱙝", hl = "MiniIconsBlue" },
    ["json.kulala_ui"] = { glyph = "󰏚", hl = "MiniIconsWhite" },
    ["text.kulala_ui"] = { glyph = "󰏚", hl = "MiniIconsWhite" },
    ["terminal"]       = { glyph = "", hl = "MiniIconsPurple" },
    ["tmux"]           = { glyph = "", hl = "MiniIconsGreen" },
    ["nvim-pack"]      = { glyph = "", hl = "MiniIconsGreen" }
    -- stylua: ignore end
  },
  lsp = {
    -- stylua: ignore start
    ["copilot"] = { glyph = "", hl = "MiniIconsOrange" },
    ["snippet"] = { glyph = "", hl = "MiniIconsGreen" },
    -- stylua: ignore end
  },
  os = {},
})

icons.mock_nvim_web_devicons()
icons.tweak_lsp_kind()

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function gen_hl_groups() vim.api.nvim_set_hl(0, "MiniIconsWhite", { link = "White" }) end

gen_hl_groups() -- Call this now if colorscheme was already set

local group = vim.api.nvim_create_augroup("mini_icons", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})
