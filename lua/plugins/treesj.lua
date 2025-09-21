local treesj = require("treesj")
local splitjoin = require("mini.splitjoin")

local utils = require("utils")

local langs = require("treesj.langs").presets

-- Add fallback to all language
for _, nodes in pairs(langs) do
  nodes.comment = {
    both = {
      fallback = function(tsn)
        -- mini.splitjoin returns `nil` if nothing to toggle
        local res = splitjoin.toggle()

        if not res then
          vim.cmd("normal! gww")
        end
      end,
    },
  }
end

treesj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 1000,
  cursor_behavior = "hold",
  notify = true,
  dot_repeat = true,
})

utils.map("n", "J", "<cmd>TSJToggle<cr>", { desc = "Split/Join" })
