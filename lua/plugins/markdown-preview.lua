return {
  "0x00-ketsu/markdown-preview.nvim",
  ft = { "md", "markdown", "mkd", "mkdn", "mdwn", "mdown", "mdtxt", "mdtext", "rmd", "wiki" },
  opts = function()
    return {
      glow = {
        -- When find executable path of `glow` failed (from PATH), use this value instead
        exec_path = "",
      },
      -- Markdown preview term
      term = {
        -- reload term when rendered markdown file changed
        reload = {
          enable = true,
          events = { "InsertLeave", "TextChanged" },
        },
        direction = "vertical", -- choices: vertical / horizontal
        keys = {
          close = { "q", "<Esc>" },
          refresh = "r",
        },
      },
    }
  end,
  config = function(_, opts)
    require("markdown-preview").setup(opts)
  end,
}
