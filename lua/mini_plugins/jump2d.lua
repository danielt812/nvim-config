local jump2d = require("mini.jump2d")

local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function jump()
  local builtin = jump2d.builtin_opts.word_start
  builtin.view = { n_steps_ahead = 10 }
  jump2d.start(builtin)
end

jump2d.setup({
  mappings = {
    start_jumping = "",
  },
  view = {
    dim = true,
    n_steps_ahead = 10,
  },
})

map({ "n", "x", "o" }, "<leader>ej", jump, { desc = "Jump" })
