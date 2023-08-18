return {
  "FabijanZulj/blame.nvim",
  event = { "BufRead" },
  opts = function()
    return {
      date_format = "%Y/%m/%d %H:%M",
      width = 50,
      virtual_style = "right_align",
    }
  end,
  config = function(_, opts)
    require("blame").setup(opts)
  end,
}
