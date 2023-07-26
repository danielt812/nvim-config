return {
  "rebelot/kanagawa.nvim",
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  event = { "BufRead" },
  -- priority = 1000, -- make sure to load this before all the other start plugins
  opts = function()
    return {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      theme = "dragon", -- Load "wave" theme when 'background' option is not set
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    }
  end,
  config = function(_, opts)
    require("kanagawa").setup(opts)
    -- Load the colorscheme here
    -- vim.cmd("colorscheme kanagawa")
  end,
}
