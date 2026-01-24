local comment = require("mini.comment")

comment.setup({
  mappings = {
    comment = "gc",
    comment_line = "gcc",
    textobject = "gc",
  },
  options = {
    ignore_blank_line = true,
    pad_comment = false,
    custom_commentstring = function()
      local ok, ts_context_commentstring = pcall(require, "ts_context_commentstring.internal")
      if ok then
        return ts_context_commentstring.calculate_commentstring() or vim.bo.commentstring
      else
        return vim.bo.commentstring
      end
    end,
  },
  commentstring = {
    enable = true,
    fallback = "# %s",
  },
})

local box = require("utils.comment-box")
vim.keymap.set("n", "gcb", box.toggle_box,  { desc = "Comment box" })
vim.keymap.set("n", "gcl", box.toggle_line, { desc = "Comment box" })
