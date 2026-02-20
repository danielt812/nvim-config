local jump2d = require("mini.jump2d")

jump2d.setup({
  mappings = {
    start_jumping = "",
  },
  view = {
    dim = true,
    n_steps_ahead = 10,
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local jump = function()
  local builtin = jump2d.builtin_opts.word_start
  builtin.view = { n_steps_ahead = 10 }
  jump2d.start(builtin)
end

vim.keymap.set({ "n", "x", "o" }, "<cr>", jump, { desc = "Jump" })
