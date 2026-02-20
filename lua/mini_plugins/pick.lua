local pick = require("mini.pick")
local extra = require("mini.extra")

pick.setup({
  mappings = {
    mark = "<C-x>",
    mark_all = "<C-a>",
    move_down = "<C-j>",
    move_start = "<C-g>",
    move_up = "<C-k>",
    sys_paste = {
      char = "<C-v>",
      func = function() pick.set_picker_query({ vim.fn.getreg("+") }) end,
    },
  },
})

local pick_colorschemes = function()
  local config = vim.fn.stdpath("config")
  local names = vim.tbl_filter(function(name)
    local files = vim.list_extend(
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".vim", false),
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".lua", false)
    )
    for _, path in ipairs(files) do
      if vim.startswith(path, config) then return true end
    end
    return false
  end, vim.fn.getcompletion("", "color"))
  extra.pickers.colorschemes({ names = names })
end

-- NOTE: Only filter my colorschemes
vim.keymap.set("n", "<leader>fc", pick_colorschemes, { desc = "Colorschemes" })

-- stylua: ignore start
vim.keymap.set("n", "<leader>fe", "<cmd>Pick explorer<cr>",     { desc = "Explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>",        { desc = "Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>",    { desc = "Livegrep" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>",         { desc = "Help" })
vim.keymap.set("n", "<leader>fi", "<cmd>Pick hl_groups<cr>",    { desc = "Highlights" })
vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>",      { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fl", "<cmd>Pick buf_lines<cr>",    { desc = "Lines" })
vim.keymap.set("n", "<leader>fm", "<cmd>Pick marks<cr>",        { desc = "Marks" })
-- stylua: ignore end
