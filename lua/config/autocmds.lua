vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("comment_fmt_opts", { clear = true }),
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
  -- stylua: ignore
  callback = vim.schedule_wrap(function()
    vim.cmd("wincmd L")
  end),
})

local term_group = vim.api.nvim_create_augroup("terminal_window", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*" },
  group = term_group,
  desc = "Use Terminal highlight in terminal windows",
  -- stylua: ignore
  callback = vim.schedule_wrap(function()
    if vim.bo.buftype == "terminal" then
      vim.wo.winhighlight = "Normal:Terminal"
      vim.cmd("startinsert")
    end
  end),
})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = { "term://*" },
  group = term_group,
  desc = "Clear Terminal highlight on close",
  -- stylua: ignore
  callback = vim.schedule_wrap(function()
    vim.wo.winhighlight = ""
  end),
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "*" },
  group = term_group,
  desc = "Set terminal ANSI palette",
  callback = function()
    -- stylua: ignore start
    vim.g.terminal_color_0  = "#000000"
    vim.g.terminal_color_1  = "#ff0000"
    vim.g.terminal_color_2  = "#00ff00"
    vim.g.terminal_color_3  = "#ff5f00"
    vim.g.terminal_color_4  = "#1a8fff"
    vim.g.terminal_color_5  = "#ff005f"
    vim.g.terminal_color_6  = "#00ffff"
    vim.g.terminal_color_7  = "#ffffff"
    vim.g.terminal_color_8  = "#767676"
    vim.g.terminal_color_9  = "#ff0000"
    vim.g.terminal_color_10 = "#00ff00"
    vim.g.terminal_color_11 = "#ff5f00"
    vim.g.terminal_color_12 = "#1a8fff"
    vim.g.terminal_color_13 = "#ff005f"
    vim.g.terminal_color_14 = "#00ffff"
    vim.g.terminal_color_15 = "#ffffff"
    -- stylua: ignore end
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

vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  desc = "Turn off some features on large files",
  callback = function(args)
    local file = args.file
    local buf = args.buf
    local max_filesize = 1024 * 200 -- 200 KB threshold, adjust as needed
    local ok, stats = pcall(vim.uv.fs_stat, file)
    if ok and stats and stats.size > max_filesize then
      vim.schedule(function()
        if vim.treesitter.highlighter then vim.treesitter.stop(buf) end
        vim.bo[buf].syntax = "off"
        vim.b[buf].minianimate_disable = true
        vim.b[buf].minihipatterns_disable = true
        vim.b[buf].miniindentscope_disable = true
        vim.notify("Large file detected", vim.log.levels.WARN)
      end)
    end
  end,
})
