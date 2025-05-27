local clue = require("mini.clue")

clue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<leader>" },
    { mode = "x", keys = "<leader>" },
    -- Bracketed triggers
    { mode = "n", keys = "]" },
    { mode = "n", keys = "[" },
    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },

    -- `m` key
    { mode = "n", keys = "m" },
    { mode = "x", keys = "m" },
  },
  clues = {
    -- stylua: ignore start
    { mode = "n", keys = "<leader>b",  desc = "+Buffer" },
    { mode = "n", keys = "<leader>d",  desc = "+Debug" },
    { mode = "n", keys = "<leader>e",  desc = "+Editor" },
    { mode = "n", keys = "<leader>f",  desc = "+Find" },
    { mode = "n", keys = "<leader>g",  desc = "+Git" },
    { mode = "n", keys = "<leader>n",  desc = "+Notify" },
    { mode = "n", keys = "<leader>s",  desc = "+Snipe" },
    -- stylua: ignore end
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
