local clue = require("mini.clue")

clue.setup({
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<leader>" },

    -- Bracketed triggers
    { mode = "n", keys = "]" },
    { mode = "n", keys = "[" },
    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = { "n", "x" }, keys = "g" },

    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    { mode = { "n", "x" }, keys = "m" },

    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = { "n", "x" }, keys = "z" },
  },
  clues = {
    { mode = "n", keys = "gb", desc = "Box" },
    { mode = { "n", "v" }, keys = "gl", desc = "Lsp" },
    -- stylua: ignore start
    { mode = {"n", "v"}, keys = "<leader>b",  desc = "+Buffer" },
    { mode = {"n", "v"}, keys = "<leader>d",  desc = "+Debugger" },
    { mode = {"n", "v"}, keys = "<leader>e",  desc = "+Editor" },
    { mode = {"n", "v"}, keys = "<leader>f",  desc = "+Find" },
    { mode = {"n", "v"}, keys = "<leader>g",  desc = "+Git" },
    { mode = {"n", "v"}, keys = "<leader>l",  desc = "+Lsp" },
    { mode = {"n", "v"}, keys = "<leader>n",  desc = "+Notify" },
    { mode = {"n", "v"}, keys = "<leader>o",  desc = "+Overseer" },
    { mode = {"n", "v"}, keys = "<leader>q",  desc = "+Quick Fix" },
    { mode = {"n", "v"}, keys = "<leader>s",  desc = "+Sessions" },

    -- stylua: ignore end
    clue.gen_clues.square_brackets(),
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.z(),
  },
  window = {
    delay = 0,
    width = "auto",
    border = "single",
  },
})
