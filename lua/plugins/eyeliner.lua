return {
  "jinh0/eyeliner.nvim",
  enabled = false, -- Disabling for now while I use hop
  keys = { "f", "F" },
  opts = function()
    return {
      highlight_on_key = true, -- show highlights only after keypress
      dim = true, -- dim all other characters if set to true (recommended!)
    }
  end,
  config = function(_, opts)
    require("eyeliner").setup(opts)
  end,
}
