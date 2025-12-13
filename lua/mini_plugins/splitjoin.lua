local splitjoin = require("mini.splitjoin")

local curly = { brackets = { "%b{}" } }

-- stylua: ignore start
local add_comma_curly = splitjoin.gen_hook.add_trailing_separator(curly)
local del_comma_curly = splitjoin.gen_hook.del_trailing_separator(curly)
local pad_curly       = splitjoin.gen_hook.pad_brackets(curly)
-- stylua: ignore end

splitjoin.setup({
  mappings = {
    toggle = "",
    split = "<leader>es",
    join = "<leader>ej",
  },
  detect = {
    brackets = { "%b()", "%b[]", "%b{}" },
    separator = ",",
    exclude_regions = nil,
  },
  split = {
    hooks_pre = {},
    hooks_post = { add_comma_curly },
  },
  join = {
    hooks_pre = {},
    hooks_post = { del_comma_curly, pad_curly },
  },
})
