local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("BufWritePre", {
  group = augroup("format_on_save", { clear = true }),
  desc = "Format on save",
  pattern = { "*.lua", "*.js", "*.jsx", "*.json", "*.jsonc", "*.py", "*.scss", "*.css", "*.zsh", "*.sh" },
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

au("BufReadPost", {
  group = augroup("coldfusion_filetype", { clear = true }),
  desc = "Set coldfusion filetype",
  pattern = { "*.cfml", "*.inc" },
  callback = function()
    vim.cmd("set filetype=cf")
  end,
})

au("BufReadPost", {
  group = augroup("env_filetype", { clear = true }),
  desc = "Set env filetype",
  pattern = { "*.env*" },
  callback = function()
    vim.cmd("set filetype=sh")
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

au("QuitPre", {
  group = augroup("auto_close_windows_on_quit", { clear = true }),
  desc = "Auto close plugin windows on quit",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype

      -- match by filetype
      if ft == "dap-view" or ft == "grug-far" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end,
})
