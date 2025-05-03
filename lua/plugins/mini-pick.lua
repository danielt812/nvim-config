local M = { "echasnovski/mini.pick" }

M.enabled = false

M.cmd = { "Pick" }

M.keys = {
  { "<leader>ff", "<cmd>Pick files<cr>", desc = "Files  " },
  { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Livegrep  " },
  { "<leader>fh", "<cmd>Pick hl_groups<cr>", desc = "Highlights 󰸱 " },
  { "<leader>fl", "<cmd>Pick help<cr>", desc = "Help 󰋖 " },
  { "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Keymaps  " },
}

M.opts = function()
  return {
    mappings = {
      move_down = "<C-j>",
      move_start = "<C-g>",
      move_up = "<C-k>",

      sys_paste = {
        char = "<C-v>",
        func = function()
          require("mini.pick").set_picker_query({ vim.fn.getreg("+") })
        end,
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.pick").setup(opts)
end

return M
