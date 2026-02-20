vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("comment_new_line", { clear = true }),
  desc = "No comment on new line",
  -- stylua: ignore
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  group = vim.api.nvim_create_augroup("open_help_vs", { clear = true }),
  desc = "Open help files in vertical split",
  callback = function()
    -- stylua: ignore
    vim.schedule(function()
      vim.cmd("wincmd L")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.cfml", "*.inc" },
  group = vim.api.nvim_create_augroup("coldfusion_filetype", { clear = true }),
  desc = "Set coldfusion filetype",
  -- stylua: ignore
  callback = function()
    vim.cmd("set filetype=cf")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.env*" },
  group = vim.api.nvim_create_augroup("env_filetype", { clear = true }),
  desc = "Set env filetype",
  -- stylua: ignore
  callback = function()
    vim.cmd("set filetype=sh")
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("resize_window", { clear = true }),
  desc = "Resize windows evenly on screen resize",
  -- stylua: ignore
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("auto_close_windows_on_quit", { clear = true }),
  desc = "Auto close plugin windows on quit",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == "dap-view" or ft == "qf" then pcall(vim.api.nvim_win_close, win, true) end
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("defer_treesitter", { clear = true }),
  desc = "Defer treesitter on large files",
  callback = function(args)
    local file = args.file
    local max_filesize = 1024 * 200 -- 200 KB threshold, adjust as needed
    local ok, stats = pcall(vim.loop.fs_stat, file)
    if ok and stats and stats.size > max_filesize then
      vim.schedule(function()
        if vim.treesitter.highlighter then vim.treesitter.stop(args.buf) end

        vim.notify("Large file detected — deferring Tree-sitter", vim.log.levels.WARN)
      end)

      vim.defer_fn(function() vim.treesitter.start(args.buf) end, 3000)
    end
  end,
})
