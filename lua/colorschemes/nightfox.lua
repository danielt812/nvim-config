return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      options = {
        transparent = false, -- Disable setting background
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false, -- Non focused panes set to alternative background
        module_default = true, -- Default enable value for modules
        styles = { -- Style to be applied to different syntax groups
          comments = "italic", -- Value is any valid attr-list value `:help attr-list`
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "italic",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = { -- Inverse highlight for different types
          match_paren = false,
          visual = false,
          search = false,
        },
      },
      palettes = {},
      specs = {},
      groups = {},
    }
  end,
  config = function(_, opts)
    require("nightfox").setup(opts)
    -- Load the colorscheme here
    vim.cmd("colorscheme carbonfox")
  end,
}
