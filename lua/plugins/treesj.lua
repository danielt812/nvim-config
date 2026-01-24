local treesj = require("treesj")
local splitjoin = require("mini.splitjoin")

local function in_arrow_function()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return false
  end

  while node do
    if node:type() == "arrow_function" then
      return true
    end
    node = node:parent()
  end

  return false
end

local function split_join_toggle()
  -- Prefer treesj in arrow functions
  if in_arrow_function() then
    vim.notify("treesj")
    treesj.toggle()
    return
  end

  -- Prefer mini for bracket-based constructs
  if splitjoin.toggle() then
    vim.notify("splitjoin")
    return
  end

  -- Otherwise, let treesj try (keywords, params, JSX, etc.)
  vim.notify("treesj")
  treesj.toggle()
end

treesj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 10000,
  cursor_behavior = "hold",
  notify = true,
  dot_repeat = true,
})

-- stylua: ignore start
vim.keymap.set({ "n" }, "J", split_join_toggle, { desc = "Split/Join" })
vim.keymap.set({ "x" }, "J", treesj.toggle,     { desc = "Split/Join" })
-- stylua: ignore end
