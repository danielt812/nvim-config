vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("comment_fmt_opts", { clear = true }),
  desc = "No comment on new line",
  callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("open_help_vs", { clear = true }),
  desc = "Open help/man files in vertical split",
  callback = vim.schedule_wrap(function()
    if vim.o.columns <= 110 then return end
    if vim.bo.buftype == "help" or vim.bo.filetype == "man" then
      vim.cmd("wincmd L")
    end
  end),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("preserve_cursor", { clear = true }),
  desc = "Preserve cursor position on yank",
  callback = function()
    local pos = vim.w._yank_cursor_pos
    if pos then
      vim.api.nvim_win_set_cursor(0, pos)
      vim.w._yank_cursor_pos = nil
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { ".env*" },
  group = vim.api.nvim_create_augroup("env_filetype", { clear = true }),
  desc = "Set env filetype",
  callback = function() vim.cmd("set filetype=sh") end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize_window", { clear = true }),
  desc = "Resize windows evenly, skip when terminal split is open",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then return end
    end
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("auto_close_windows", { clear = true }),
  desc = "Auto close plugin windows on quit",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == "dap-view" or ft == "qf" then pcall(vim.api.nvim_win_close, win, true) end
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("auto_checktime", { clear = true }),
  desc = "Reload files changed outside of Neovim",
  callback = function() vim.cmd("checktime") end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  desc = "Turn off some features on large files",
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, args.file)
    if ok and stats and stats.size > 1024 * 1024 then -- 1 MB
      vim.schedule(function()
        if vim.bo[args.buf].buftype == "help" then return end
        if vim.treesitter.highlighter then vim.treesitter.stop(args.buf) end
        vim.bo[args.buf].syntax = "off"
        vim.b[args.buf].minianimate_disable = true
        vim.b[args.buf].minihipatterns_disable = true
        vim.b[args.buf].miniindentscope_disable = true
        vim.notify("Large file detected", vim.log.levels.WARN)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("angular_filetype", { clear = true }),
  pattern = "*.html",
  desc = "Set htmlangular filetype for Angular templates",
  callback = function(args)
    if vim.fs.root(vim.api.nvim_buf_get_name(args.buf), "angular.json") then
      vim.bo[args.buf].filetype = "htmlangular"
      vim.treesitter.start(args.buf)
    end
  end,
})
