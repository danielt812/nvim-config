local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("BufReadPost", {
  group = augroup("last_location", { clear = true }),
  desc = "Buffer last location",
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

au("BufWritePre", {
  group = augroup("format_on_save", { clear = true }),
  desc = "Format on save",
  pattern = { "*.lua", "*.js", "*.jsx", "*.json", "*.py", "*.scss", "*.css", "*.zsh", "*.sh" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

au("BufEnter", {
  group = augroup("comment_new_line", { clear = true }),
  desc = "No comment on new line",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

au("FileType", {
  group = augroup("open_help_vs", { clear = true }),
  desc = "Open help files in vertical split",
  pattern = { "help", "man" },
  callback = function()
    vim.cmd("wincmd L")
  end,
})

au("BufReadPre", {
  group = augroup("coldfusion", { clear = true }),
  desc = "Set coldfusion filetype",
  pattern = { "*.cfml", "*.inc" },
  callback = function()
    vim.cmd("set filetype=cf")
  end,
})

au("VimResized", {
  group = augroup("resize_window", { clear = true }),
  desc = "Resize windows evenly on screen resize",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

au("TextYankPost", {
  group = augroup("yank_position", { clear = true }),
  desc = "Prevent cursor moving after yank",
  callback = function()
    if vim.v.event.operator == "y" and vim.b.cursor_pre_yank then
      vim.api.nvim_win_set_cursor(0, vim.b.cursor_pre_yank)
      vim.b.cursor_pre_yank = nil
    end
  end,
})
