local operators = require("mini.operators")
local ts = require("utils.ts")

operators.setup({
  {
    evaluate = {
      prefix = "g=",
    },
    exchange = {
      prefix = "gx",
    },
    multiply = {
      prefix = "gm",
    },
    replace = {
      prefix = "gr",
    },
    sort = {
      prefix = "gs",
    },
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore
local string_nodes = { "string", "string_content", "string_literal", "template_string", "interpreted_string_literal" }

local function swap(dir)
  local keys
  if ts.in_node({ "attribute", "jsx_attribute" }) then
    keys = { left = "gxargxalr", right = "gxargxanr" }
  elseif ts.in_node(string_nodes) then
    keys = { left = "gxawgxalw", right = "gxawgxanw" }
  else
    keys = { left = "gxiagxila", right = "gxiagxina" }
  end
  vim.cmd("normal " .. vim.api.nvim_replace_termcodes(keys[dir], true, true, true))
end

-- stylua: ignore start
local swap_left  = function() swap("left") end
local function swap_right() swap("right") end

vim.keymap.set("n", "(", swap_left,  { desc = "Swap left" })
vim.keymap.set("n", ")", swap_right, { desc = "Swap right" })
-- stylua: ignore end
