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

local function toggle_pairs()
  vim.b.minipairs_disable = not vim.b.minipairs_disable
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "\\4", toggle_pairs, { desc = "Toggle 'mini.pairs'" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_pairs", { clear = true })

local function disable_pairs()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then vim.g.minipairs_disable = true end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  desc = "Disable minipairs in search",
  callback = disable_pairs,
})

local function enable_pairs() vim.g.minipairs_disable = false end

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  desc = "Restore minipairs state",
  callback = enable_pairs,
})
