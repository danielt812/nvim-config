local M = { "echasnovski/mini.splitjoin" }

M.enabled = true

M.event = { "VeryLazy" }

M.keys = {
  { "J", "<cmd>lua MiniSplitjoin.toggle()<cr>", desc = "Split/Join" },
}

M.opts = function()
  local splitjoin = require("mini.splitjoin")

  local gen_hook = splitjoin.gen_hook
  local curly = { brackets = { "%b{}" } }

  -- Add trailing comma when splitting inside curly brackets
  local add_comma_curly = gen_hook.add_trailing_separator(curly)

  -- Delete trailing comma when joining inside curly brackets
  local del_comma_curly = gen_hook.del_trailing_separator(curly)

  -- Pad curly brackets with single space after join
  local pad_curly = gen_hook.pad_brackets(curly)

  return {
    mappings = {
      toggle = "gS",
      split = "",
      join = "",
    },
    detect = {
      brackets = { "%b()", "%b[]", "%b{}" },
      separator = ",",
      exclude_regions = nil,
    },
    split = {
      hooks_pre = { add_comma_curly },
      hooks_post = {},
    },
    join = {
      hooks_pre = {},
      hooks_post = { del_comma_curly, pad_curly },
    },
  }
end

M.config = function(_, opts)
  require("mini.splitjoin").setup(opts)
end

return M
