local treesj = require("treesj")

treesj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 10000,
  cursor_behavior = "hold",
  notify = true,
  dot_repeat = true,
})

local splitjoin = require("mini.splitjoin")

local on_arrow_function = function()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return false end

  if node:type() == "arrow_function" then
    return true
  end

  return false
end

local on_pair_char = function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- char under cursor
  local c1 = line:sub(col + 1, col + 1)
  -- char just left of cursor (useful when cursor is between chars)
  local c0 = (col > 0) and line:sub(col, col) or ""

  -- treat these as "pair chars"
  local pairs = { ["("] = true, [")"] = true, ["{"] = true, ["}"] = true, ["["] = true, ["]"] = true }

  return pairs[c1] == true or pairs[c0] == true
end

local split_join_toggle = function()
  -- Prefer treesj on arrow functions
  if on_arrow_function() then
    vim.notify("treesj")
    treesj.toggle()
    return
  end

  -- Prefer mini for bracket-based constructs
  if on_pair_char() and splitjoin.toggle() then
    vim.notify("splitjoin")
    return
  end

  -- Otherwise, let treesj try (keywords, params, JSX, etc.)
  vim.notify("treesj")
  treesj.toggle()
end

vim.keymap.set({ "n" }, "J", split_join_toggle, { desc = "Split/Join" })
vim.keymap.set({ "x" }, "J", treesj.toggle, { desc = "Split/Join" })
