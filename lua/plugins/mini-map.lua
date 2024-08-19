local M = { "echasnovski/mini.map" }

M.enabled = true

M.event = { "BufReadPost" }

M.init = function()
  vim.api.nvim_create_user_command("MapToggle", "lua MiniMap.toggle()", {})
  vim.api.nvim_create_user_command("MapOpen", "lua MiniMap.open()", {})
  vim.api.nvim_create_user_command("MapClose", "lua MiniMap.close()", {})
end

M.opts = function()
  local map = require("mini.map")
  return {
    -- Highlight integrations (none by default)
    integrations = {
      map.gen_integration.gitsigns(),
      map.gen_integration.diff(),
    },

    -- Symbols used to display data
    symbols = {
      -- Encode symbols. See `:h MiniMap.config` for specification and
      -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
      -- Default: solid blocks with 3x2 resolution.
      encode = nil,

      -- Scrollbar parts for view and line. Use empty string to disable any.
      scroll_line = "█",
      scroll_view = "┃",
    },

    -- Window options
    window = {
      -- Whether window is focusable in normal way (with `wincmd` or mouse)
      focusable = false,

      -- Side to stick ('left' or 'right')
      side = "right",

      -- Whether to show count of multiple integration highlights
      show_integration_count = false,

      -- Total width
      width = 10,

      -- Value of 'winblend' option
      winblend = 25,

      -- Z-index
      zindex = 10,
    },
  }
end

M.config = function(_, opts)
  require("mini.map").setup(opts)

  -- vim.cmd([[
  --   augroup MyMiniMapColors
  --     au!
  --     au ColorScheme * hi link MiniMapSymbolCount Special
  --     au ColorScheme * hi link MiniMapSymbolLine  Title
  --     au ColorScheme * hi link MiniMapSymbolView  Delimiter
  --   augroup END
  -- ]])
end

return M
