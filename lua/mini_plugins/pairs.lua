local pairs = require("mini.pairs")

pairs.setup({
  modes = {
    insert = false,
    command = true,
    terminal = true,
  },
  mappings = {
    -- stylua: ignore start
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].",   register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].",   register = { cr = false } },
    -- stylua: ignore end
  },
})

-- local function toggle_pairs()
--   vim.b.minipairs_disable = not vim.b.minipairs_disable

--   vim.notify("Pairs " .. (vim.b.minipairs_disable and "disabled" or "enabled"), vim.log.levels.INFO)
-- end

-- vim.keymap.set("n", "<leader>ep", toggle_pairs, { desc = "Pairs" })
