local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
  highlights = {
    Normal = {
      link = "Terminal",
    },
    NormalFloat = {
      link = "Terminal",
    },
    FloatBorder = {
      link = "Terminal",
    },
  },
  open_mapping = [[<c-\>]],
  direction = "vertical",
  float_opts = {
    border = "single",
    title_pos = "left",
  },
  winblend = 25,
})

local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "single",
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function()
    vim.cmd("startinsert!")
  end,
})

local terminal_vertical = Terminal:new({ direction = "vertical" })
local terminal_horizontal = Terminal:new({ direction = "horizontal" })
local terminal_float = Terminal:new({ direction = "float" })

_G.lazygit = function()
  lazygit:toggle()
end

_G.terminal_vertical = function()
  terminal_vertical:toggle()
end

_G.terminal_horizontal = function()
  terminal_horizontal:toggle()
end

_G.terminal_float = function()
  terminal_float:toggle()
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>gg", "<cmd>lua lazygit()<cr>",             { desc = "Lazygit" })
vim.keymap.set("n", "<leader>tv", "<cmd>lua terminal_vertical()<cr>",   { desc = "Vertical" })
vim.keymap.set("n", "<leader>th", "<cmd>lua terminal_horizontal()<cr>", { desc = "Horizontal" })
vim.keymap.set("n", "<leader>tf", "<cmd>lua terminal_float()<cr>",      { desc = "Float" })
-- stylua: ignore end
