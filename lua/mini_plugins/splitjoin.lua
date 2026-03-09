local splitjoin = require("mini.splitjoin")

-- stylua: ignore start
local curly  = { brackets = { "%b{}" } }
local square = { brackets = { "%b[]" } }
local paren  = { brackets = { "%b()" } }
-- stylua: ignore end

-- Disable hooks for specific filetypes
local function ft_condition(hook, disabled)
  return function(...)
    local ft = vim.bo.filetype
    if disabled[ft] then return ... end
    return hook(...)
  end
end

-- filetypes where trailing commas are invalid / undesirable
local no_trailing_comma_curly = { json = true, jsonc = true, toml = true, yaml = true, yml = true }
local no_trailing_comma_square = { json = true, jsonc = true, toml = true, yaml = true, yml = true }
local no_trailing_comma_paren = { json = true, jsonc = true, toml = true, yaml = true, yml = true }

local add_trailing_separator = splitjoin.gen_hook.add_trailing_separator
local del_trailing_separator = splitjoin.gen_hook.del_trailing_separator

-- stylua: ignore start
local add_comma_curly  = ft_condition(add_trailing_separator(curly), no_trailing_comma_curly)
local del_comma_curly  = ft_condition(del_trailing_separator(curly), no_trailing_comma_curly)
local add_comma_square = ft_condition(add_trailing_separator(square), no_trailing_comma_square)
local del_comma_square = ft_condition(del_trailing_separator(square), no_trailing_comma_square)
local del_comma_paren  = ft_condition(del_trailing_separator(paren), no_trailing_comma_paren)
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
