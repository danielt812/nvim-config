local pairs = require("mini.pairs")

pairs.setup({
  modes = { insert = true, command = true, terminal = false },
  mappings = {
    ["("] = { neigh_pattern = "[^\\][%s>)%]},:]" },
    ["["] = { neigh_pattern = "[^\\][%s>)%]},:]" },
    ["{"] = { neigh_pattern = "[^\\][%s>)%]},:]" },
    ['"'] = { neigh_pattern = "[%s<(%[{][%s>)%]},:]" },
    ["'"] = { neigh_pattern = "[%s<(%[{][%s>)%]},:]" },
    ["`"] = { neigh_pattern = "[%s<(%[{][%s>)%]},:]" },
    ["<"] = { action = "open", pair = "<>", neigh_pattern = "[\r%w\"'`].", register = { cr = false } },
    [">"] = { action = "close", pair = "<>", register = { cr = false } },
  },
})

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertCharPre" }, {
  group = vim.api.nvim_create_augroup("mini_pairs", { clear = true }),
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
