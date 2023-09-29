return {
  "SmiteshP/nvim-navic",
  event = { "LspAttach" },
  opts = function()
    return {
      icons = require("icons.kind"),
      lsp = {
        auto_attach = true,
        preference = nil,
      },
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true,
      lazy_update_context = false,
      click = true,
    }
  end,
  config = function(_, opts)
    require("nvim-navic").setup(opts)
  end,
}
