vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

require("foldtext").setup({
  ignore_filetypes = {},
  ignore_buftypes = {},

  styles = {
    default = {
      ---|fS "config: Default configuration"
      { kind = "indent" },
      { kind = "description" },
      {
        kind = "fold_size",
        condition = function(_, _, parts) return #parts > 1 end,

        padding_left = " ",
        icon = "󰘖 ",

        hl = "@conditional",
      },
      {
        kind = "fold_size",
        condition = function(_, _, parts) return #parts == 1 end,

        icon = "󰘖 ",
        padding_right = " lines folded!",

        padding_right_hl = "@comment",
        icon_hl = "@conditional",
        hl = "@number",
      },
      ---|fE
    },

    ts_expr = {
      ---|fS "config: Tree-sitter fold configuration"

      condition = function(_, window)
        return vim.wo[window].foldmethod == "expr" and vim.wo[window].foldexpr == "v:lua.vim.treesitter.foldexpr()"
      end,

      parts = {
        {
          kind = "bufline",

          delimiter = " ... ",
          hl = "Grey",
        },
        {
          kind = "fold_size",
          icon = " 󰘖 ",
          icon_hl = "Red",
          padding_right = " lines",
          padding_right_hl = "Grey",
        },
      },

      ---|fE
    },
  },
})

vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "", lastline = " " } -- Custom UI glyphs
