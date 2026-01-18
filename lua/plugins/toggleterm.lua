local toggleterm = require("toggleterm")
local terminal = require("toggleterm.terminal").Terminal

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
  close_on_exit = true,
  open_mapping = nil,
  direction = "float",
  float_opts = {
    border = "single",
    title_pos = "left",
    -- winblend = 15,
  },
})

local lazygit = terminal:new({
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

local delta = terminal:new({
  cmd = "git diff | delta --diff-so-fancy --side-by-side --line-numbers",
  dir = "git_dir",
  direction = "float",
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
})

local terminal_vertical = terminal:new({ direction = "vertical" })
local terminal_horizontal = terminal:new({ direction = "horizontal" })
local terminal_float = terminal:new({ direction = "float" })

_G.lazygit = function()
  lazygit:toggle()
end

_G.delta = function()
  delta:toggle()
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
vim.keymap.set({ "n", "t" }, "<C-t>", "<cmd>lua terminal_float()<cr>", { desc = "Float" })
vim.keymap.set({ "n", "t" }, "<C-g>", "<cmd>lua lazygit()<cr>",        { desc = "Lazygit" })
vim.keymap.set({ "n", "t" }, "<C-e>", "<cmd>lua delta()<cr>",     { desc = "Delta" })
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n",  "<leader>gg", "<cmd>lua lazygit()<cr>",             { desc = "Lazygit" })
-- vim.keymap.set("n",  "<leader>tv", "<cmd>lua terminal_vertical()<cr>",   { desc = "Vertical" })
-- vim.keymap.set("n",  "<leader>th", "<cmd>lua terminal_horizontal()<cr>", { desc = "Horizontal" })
-- vim.keymap.set("n",  "<leader>tf", "<cmd>lua terminal_float()<cr>",      { desc = "Float" })
-- stylua: ignore end
