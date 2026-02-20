local jump = require("mini.jump")

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

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local jump_stop = function()
  if not jump.state.jumping then return "<esc>" end
  jump.stop_jumping()
end

vim.keymap.set({ "n", "x" }, "<esc>", jump_stop, { expr = true })
