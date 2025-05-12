local M = { "echasnovski/mini.pick" }

M.enabled = true

M.cmd = { "Pick" }

M.keys = {
  { "<leader>fe", "<cmd>Pick explorer<cr>", desc = "Explorer" },
  { "<leader>ff", "<cmd>Pick files<cr>", desc = "Files" },
  { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Livegrep" },
  { "<leader>fh", "<cmd>Pick hl_groups<cr>", desc = "Highlights" },
  { "<leader>fl", "<cmd>Pick help<cr>", desc = "Help" },
  { "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Keymaps" },
}

M.opts = function()
  local minipick = require("mini.pick")
  return {
    mappings = {
      move_down = "<C-j>",
      move_start = "<C-g>",
      move_up = "<C-k>",
      sys_paste = {
        char = "<C-v>",
        func = function()
          minipick.set_picker_query({ vim.fn.getreg("+") })
        end,
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.pick").setup(opts)
end

return M
