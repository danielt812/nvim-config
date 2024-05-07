local M = { "Wansmer/treesj" }

M.enabled = true

M.cmd = {
  "TSJToggle",
  "TSJSplit",
  "TSJJoin",
}

M.keys = {
  { "J", "<cmd>TSJToggle<cr>" },
}

M.opts = function()
  return {
    use_default_keymaps = false,
    check_syntax_error = true,
    cursor_behavior = "hold",
    max_join_length = 999,
    dot_repeat = true,
    notify = true,
  }
end

M.config = function(_, opts)
  require("treesj").setup(opts)
end

return M
