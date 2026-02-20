local comment = require("mini.comment")

comment.setup({
  mappings = {
    comment = "gc",
    comment_line = "gcc",
    textobject = "gc",
  },
  options = {
    ignore_blank_line = false,
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

