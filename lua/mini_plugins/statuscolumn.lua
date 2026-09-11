local statuscolumn = require("mini.statuscolumn")

-- Specification is a sequence of rules applied on top of the previous ones.
-- Start with wider rules and go towards narrower ones. Undefined "info" fields
-- fall back to their defaults: fold = "%C", sign = "%s", lnum = "%l", sep = " ".
local spec = {
  -- Line-fold-sign-separator order with a visible separator
  { format = "=lfs", sep = "▏" },

  -- Custom symbol for virtual lines
  { ltype = "virt", lnum = "•" },

  -- Custom symbol for wrapped lines
  { ltype = "wrap", lnum = "↳" },

  -- Hide separator to better indicate inactive windows
  { win = "inactive", sep = " " },
}

statuscolumn.setup({
  -- Statuscolumn content as functions that return statusline-like string
  content = statuscolumn.gen_content.main(spec),

  -- Whether to dim column content in inactive windows
  dim_inactive = true,
})
