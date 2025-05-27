local pick = require("mini.pick")

pick.setup({
  mappings = {
    move_down = "<C-j>",
    move_start = "<C-g>",
    move_up = "<C-k>",
    sys_paste = {
      char = "<C-v>",
      func = function()
        pick.set_picker_query({ vim.fn.getreg("+") })
      end,
    },
  },
})

local utils = require("utils")

-- stylua: ignore start
utils.map("n", "<leader>fc", "<cmd>Pick colorschemes<cr>", { desc = "Colorschemes" })
utils.map("n", "<leader>fe", "<cmd>Pick explorer<cr>",     { desc = "Explorer" })
utils.map("n", "<leader>ff", "<cmd>Pick files<cr>",        { desc = "Files" })
utils.map("n", "<leader>fg", "<cmd>Pick grep_live<cr>",    { desc = "Livegrep" })
utils.map("n", "<leader>fl", "<cmd>Pick hl_groups<cr>",    { desc = "Highlights" })
utils.map("n", "<leader>fh", "<cmd>Pick help<cr>",         { desc = "Help" })
utils.map("n", "<leader>fk", "<cmd>Pick keymaps<cr>",      { desc = "Keymaps" })
-- stylua: ignore end
