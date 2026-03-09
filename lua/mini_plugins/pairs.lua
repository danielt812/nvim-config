local pairs = require("mini.pairs")

pairs.setup({
  modes = {
    insert = true,
    command = true,
    terminal = true,
  },
  mappings = {
    -- stylua: ignore start
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%s>)%]},:]" },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%s>)%]},:]" },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%s>)%]},:]" },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[%s<(%[{][%s>)%]},:]", register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[%s<(%[{][%s>)%]},:]", register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[%s<(%[{][%s>)%]},:]", register = { cr = false } },
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

vim.keymap.set("n", "<leader>\\p", toggle_pairs, { desc = "Pairs" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_pairs", { clear = true })

local function disable_pairs()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then vim.g.minipairs_disable = true end
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  group = group,
  desc = "Disable minipairs in search",
  callback = disable_pairs,
})

local function enable_pairs() vim.g.minipairs_disable = false end

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  group = group,
  desc = "Restore minipairs state",
  callback = enable_pairs,
})
