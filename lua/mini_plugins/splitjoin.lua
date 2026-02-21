local splitjoin = require("mini.splitjoin")

-- stylua: ignore start
local curly  = { brackets = { "%b{}" } }
local square = { brackets = { "%b[]" } }
local paren  = { brackets = { "%b()" } }
-- stylua: ignore end

-- Disable hooks for specific filetypes
local ft_condition = function(hook, disabled)
  return function(...)
    local ft = vim.bo.filetype
    if disabled[ft] then return ... end
    return hook(...)
  end
end

-- filetypes where trailing commas are invalid / undesirable
local no_trailing_comma = { json = true, jsonc = true, toml = true, yaml = true, yml = true }

local gen_hook = splitjoin.gen_hook
local add_trailing_separator = gen_hook.add_trailing_separator
local del_trailing_separator = gen_hook.del_trailing_separator

-- stylua: ignore start
local add_comma_curly  = ft_condition(add_trailing_separator(curly), no_trailing_comma)
local del_comma_curly  = ft_condition(del_trailing_separator(curly), no_trailing_comma)
local add_comma_square = ft_condition(add_trailing_separator(square), no_trailing_comma)
local del_comma_square = ft_condition(del_trailing_separator(square), no_trailing_comma)
local del_comma_paren  = ft_condition(del_trailing_separator(paren), no_trailing_comma)
-- stylua: ignore end

local pad_curly = splitjoin.gen_hook.pad_brackets(curly)

splitjoin.setup({
  mappings = {
    toggle = "",
    split = "gS",
    join = "gJ",
  },
  detect = {
    brackets = { "%b()", "%b[]", "%b{}" },
    separator = ",",
    exclude_regions = { "%b()", "%b[]", "%b{}", '%b""', "%b''" },
  },
  split = {
    hooks_post = { add_comma_curly, add_comma_square },
  },
  join = {
    hooks_post = { del_comma_curly, del_comma_square, del_comma_paren, pad_curly },
  },
})
