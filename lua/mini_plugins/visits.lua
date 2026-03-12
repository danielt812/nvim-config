local visits = require("mini.visits")

visits.setup({
  list = {
    filter = nil,
    sort = visits.gen_sort.z(),
  },

  silent = false,

  store = {
    autowrite = true,
    normalize = nil,
    path = vim.fn.stdpath("data") .. "/mini-visits-index",
  },

  track = {
    event = "BufEnter",
    delay = 1000,
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
local add_label    = function() visits.add_label() end
local remove_label = function() visits.remove_label() end
local select_label = function() visits.select_label() end

vim.keymap.set("n", "<leader>va", add_label,    { desc = "Add label" })
vim.keymap.set("n", "<leader>vr", remove_label, { desc = "Remove label" })
vim.keymap.set("n", "<leader>vs", select_label, { desc = "Select label" })
-- stylua: ignore end
