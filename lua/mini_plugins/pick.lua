local pick = require("mini.pick")

pick.setup({
  mappings = {
    mark = "<C-x>",
    mark_all = "<C-a>",
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

-- stylua: ignore start
vim.keymap.set("n", "<leader>fc", "<cmd>Pick colorschemes<cr>", { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>fe", "<cmd>Pick explorer<cr>",     { desc = "Explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>",        { desc = "Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>",    { desc = "Livegrep" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>",         { desc = "Help" })
vim.keymap.set("n", "<leader>fl", "<cmd>Pick hl_groups<cr>",    { desc = "Highlights" })
vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>",      { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fm", "<cmd>Pick marks<cr>",        { desc = "Marks" })
-- stylua: ignore end
