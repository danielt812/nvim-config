local M = { "smoka7/hop.nvim" }

M.enabled = true

M.keys = { "f", "F", "t", "T" }

M.opts = function()
  return {
    keys = "asdghklqwertyuiopzxcvbnmfj",
    quit_key = "<Esc>",
    perm_method = require("hop.perm").TrieBacktrackFilling,
    reverse_distribution = false,
    teasing = true,
    jump_on_sole_occurrence = true,
    case_insensitive = true,
    create_hl_autocmd = true,
    current_line_only = false,
    uppercase_labels = false,
    multi_windows = false,
    hint_position = require("hop.hint").HintPosition.BEGIN,
    hint_offset = 0,
  }
end

M.config = function(_, opts)
  local hop = require("hop")

  hop.setup(opts)

  local directions = require("hop.hint").HintDirection

  vim.keymap.set("", "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end, { remap = true })
  vim.keymap.set("", "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end, { remap = true })
  vim.keymap.set("", "t", function()
    hop.hint_char2({ direction = directions.AFTER_CURSOR, current_line_only = false })
  end, { remap = true })
  vim.keymap.set("", "T", function()
    hop.hint_char2({ direction = directions.BEFORE_CURSOR, current_line_only = false })
  end, { remap = true })
end

return M
