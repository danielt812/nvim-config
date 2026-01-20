local pairs = require("mini.pairs")

pairs.setup({
  modes = {
    insert = true,
    command = true,
    terminal = true,
  },
  mappings = {
    -- stylua: ignore start
    ["("] = { action = "open", pair = "()", neigh_pattern = ".[^%w_\\]" },
    ["["] = { action = "open", pair = "[]", neigh_pattern = ".[^%w_\\]" },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = ".[^%w_\\]" },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w_][^%w_]",   register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w_\\][^%w_]", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w_][^%w_]",   register = { cr = false } },
    -- stylua: ignore end
  },
})

-- stylua: ignore
local function toggle_pairs() vim.b.minipairs_disable = not vim.b.minipairs_disable end

vim.keymap.set("n", "<leader>ep", toggle_pairs, { desc = "Pairs" })
