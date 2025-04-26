local M = { "echasnovski/mini.pairs" }

M.enabled = true

M.event = { "InsertEnter" }

M.opts = function()
  return {
    modes = { insert = true, command = true, terminal = false },
    mappings = {
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

      [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w\\].", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w\\].", register = { cr = false } },
    },
  }
end

M.config = function(_, opts)
  require("mini.pairs").setup(opts)
end

return M
