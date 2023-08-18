return {
  "luukvbaal/statuscol.nvim",
  enabled = false, -- Wait for neovim to improve statuscolumn before enabling this plugin
  event = { "BufRead" },
  opts = function()
    local builtin = require("statuscol.builtin")
    return {
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        {
          sign = { name = { "Diagnostic" }, maxwidth = 1, auto = false },
          click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
        {
          sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = false, wrap = false },
          click = "v:lua.ScSa",
        },
      },
      clickhandlers = { -- builtin click handlers
        Lnum = builtin.lnum_click,
        FoldClose = builtin.foldclose_click,
        FoldOpen = builtin.foldopen_click,
        FoldOther = builtin.foldother_click,
        DapBreakpointRejected = builtin.toggle_breakpoint,
        DapBreakpoint = builtin.toggle_breakpoint,
        DapBreakpointCondition = builtin.toggle_breakpoint,
        DiagnosticSignError = builtin.diagnostic_click,
        DiagnosticSignHint = builtin.diagnostic_click,
        DiagnosticSignInfo = builtin.diagnostic_click,
        DiagnosticSignWarn = builtin.diagnostic_click,
        GitSignsTopdelete = builtin.gitsigns_click,
        GitSignsUntracked = builtin.gitsigns_click,
        GitSignsAdd = builtin.gitsigns_click,
        GitSignsChange = builtin.gitsigns_click,
        GitSignsChangedelete = builtin.gitsigns_click,
        GitSignsDelete = builtin.gitsigns_click,
        gitsigns_extmark_signs_ = builtin.gitsigns_click,
      },
    }
  end,
  config = function(_, opts)
    require("statuscol").setup(opts)
  end,
}
