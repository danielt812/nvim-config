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

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w_\\][^%w_]", register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w_\\][^%w_]", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w_][^%w_]",   register = { cr = false } },
    -- stylua: ignore end
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local toggle_pairs = function() vim.b.minipairs_disable = not vim.b.minipairs_disable end

vim.keymap.set("n", "<leader>ep", toggle_pairs, { desc = "Pairs" })

-- #############################################################################
-- #                            Automatic commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_pairs", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  group = group,
  desc = "Disable minipairs in search",
  callback = function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == "/" or cmdtype == "?" then vim.g.minipairs_disable = true end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  group = group,
  desc = "Restore minipairs state",
  callback = function() vim.g.minipairs_disable = false end,
})
