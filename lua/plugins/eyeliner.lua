local demicolon = require("demicolon")
local eyeliner = require("eyeliner")

local utils = require("utils")

demicolon.setup({
  horizontal_motions = false,
})

eyeliner.setup({
  highlight_on_key = true,
  dim = true,
  default_keymaps = false,
  disabled_filetypes = { "ministarter", "minifiles", "minipick" },
})

local function eyeliner_jump(key)
  local forward = vim.list_contains({ "t", "f" }, key)
  return function()
    eyeliner.highlight({ forward = forward })
    return require("demicolon.jump").horizontal_jump(key)()
  end
end

utils.map({ "n", "x", "o" }, "f", eyeliner_jump("f"), { expr = true })
utils.map({ "n", "x", "o" }, "F", eyeliner_jump("F"), { expr = true })
utils.map({ "n", "x", "o" }, "t", eyeliner_jump("t"), { expr = true })
utils.map({ "n", "x", "o" }, "T", eyeliner_jump("T"), { expr = true })
