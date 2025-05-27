local M = {}

--- Create a keymap with default options.
---
--- This function wraps `vim.keymap.set` to apply consistent defaults,
--- such as setting `silent = true` unless explicitly set to `false`.
---
--- Example:
--- ```lua
--- M.map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
--- M.map({ "n", "v" }, "J", ":move '>+1<CR>gv=gv", { silent = false, noremap = true })
--- ```
---
--- @param mode string|table Mode(s) in which the mapping applies (e.g. `"n"`, `"i"`, or `{ "n", "v" }`).
--- @param lhs string The left-hand side (key sequence to trigger the mapping).
--- @param rhs string|function The right-hand side (command or Lua function to execute).
--- @param opts? table Optional keymap options (e.g., `noremap`, `expr`, `desc`). `silent` defaults to `true` unless explicitly set to `false`.
M.map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
