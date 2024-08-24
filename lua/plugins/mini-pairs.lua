local M = { "echasnovski/mini.pairs" }

M.enabled = true

M.event = { "InsertEnter" }

M.opts = function()
  return {
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },

    -- Global mappings. Each right hand side should be a pair information, a
    -- table with at least these fields (see more in |MiniPairs.map|):
    -- - <action> - one of 'open', 'close', 'closeopen'.
    -- - <pair> - two character string for pair to be used.
    -- By default pair is not inserted after `\`, quotes are not recognized by
    -- `<CR>`, `'` does not insert pair after a letter.
    -- Only parts of tables can be tweaked (others will use these defaults).
    mappings = {
      -- Prevents the action if the cursor is just before any character or next to a "\".
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%s%)%]%}]" },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%s%)%]%}]" },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%s%)%]%}]" },
      -- This is default (prevents the action if the cursor is just next to a "\").
      [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
      -- Prevents the action if the cursor is just before or next to any character.
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%w][^%w]", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%w][^%w]", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%w][^%w]", register = { cr = false } },
    },
  }
end

M.config = function(_, opts)
  require("mini.pairs").setup(opts)
end

return M
