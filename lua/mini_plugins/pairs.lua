local pairs = require("mini.pairs")

-- local word_pattern = "[^%w][^%w]"
local word_pattern = [=[[%w%%%'%[%"%.%`%$]]=]

pairs.setup({
  modes = { insert = true, command = true, terminal = false },
  mappings = {
    ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
    ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
    ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

    [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
    ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
    ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

    ['"'] = { action = "closeopen", pair = '""', neigh_pattern = word_pattern, register = { cr = false } },
    ["'"] = { action = "closeopen", pair = "''", neigh_pattern = word_pattern, register = { cr = false } },
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = word_pattern, register = { cr = false } },
  },
})

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local group = augroup("mini_pairs", { clear = true })

au({ "InsertEnter", "InsertCharPre" }, {
  group = group,
  desc = "Disable mini.pairs inside Tree-sitter string nodes",
  callback = function()
    local ts_utils = require("nvim-treesitter.ts_utils")
    local node = ts_utils.get_node_at_cursor()

    while node do
      if node:type() == "string" or node:type() == "string_fragment" or node:type() == "interpreted_string_literal" then
        vim.b.minipairs_disable = true
        return
      end
      node = node:parent()
    end

    -- Not in a string node
    vim.b.minipairs_disable = false
  end,
})
