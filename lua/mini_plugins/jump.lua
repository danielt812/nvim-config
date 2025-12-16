local jump = require("mini.jump")
local keymap = require("mini.keymap")

local map_combo = keymap.map_combo

jump.setup({
  mappings = {
    forward = "f",
    backward = "F",
    forward_till = "t",
    backward_till = "T",
    repeat_jump = ";",
  },
  delay = {
    highlight = 250,
    idle_stop = 10000000,
  },
  silent = false,
})

local jump_stop = function()
  -- stylua: ignore
  if not jump.state.jumping then
    return "<Esc>"
  end
  jump.stop_jumping()
end

map_combo({ "n", "i", "x", "c" }, "<Esc><Esc>", jump_stop)
