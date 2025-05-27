local misc = require("mini.misc")

misc.setup({})

local utils = require("utils")

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

utils.map("n", "<leader>ez", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "Zoom" })
