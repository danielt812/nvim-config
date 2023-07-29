return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre" },
  opts = function()
    return {
      char = "▏",
      show_trailing_blankline_indent = true,
      show_first_indent_level = true,
      use_treesitter = true,
      show_current_context = true,
      buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "help",
        "NvimTree",
      },
      space_char_blankline = " ",
    }
  end,
  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end,
}
