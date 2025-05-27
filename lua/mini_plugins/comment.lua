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
      return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
    end,
  },
  commentstring = {
    enable = true,
    fallback = "# %s",
  },
})
