vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("comment_new_line", { clear = true }),
  desc = "No comment on new line",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("open_help_vs", { clear = true }),
  desc = "Open help files in vertical split",
  pattern = { "help", "man" },
  callback = function()
    vim.cmd("wincmd L")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("coldfusion_filetype", { clear = true }),
  desc = "Set coldfusion filetype",
  pattern = { "*.cfml", "*.inc" },
  callback = function()
    vim.cmd("set filetype=cf")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("env_filetype", { clear = true }),
  desc = "Set env filetype",
  pattern = { "*.env*" },
  callback = function()
    vim.cmd("set filetype=sh")
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("resize_window", { clear = true }),
  desc = "Resize windows evenly on screen resize",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("auto_close_windows_on_quit", { clear = true }),
  desc = "Auto close plugin windows on quit",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype

      -- match by filetype
      if ft == "dap-view" or ft == "grug-far" or ft == "qf" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("defer_treesitter", { clear = true }),
  desc = "Defer treesitter on large files",
  callback = function(args)
    local file = args.file
    local max_filesize = 1024 * 200 -- 200 KB threshold, adjust as needed
    local ok, stats = pcall(vim.loop.fs_stat, file)
    if ok and stats and stats.size > max_filesize then
      vim.schedule(function()
        if vim.treesitter.highlighter then
          vim.treesitter.stop(args.buf)
        end

        vim.notify("Large file detected — deferring Tree-sitter", vim.log.levels.WARN)
      end)

      vim.defer_fn(function()
        vim.treesitter.start(args.buf)
      end, 3000)
    end
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("mode_changed", { clear = true }),
  desc = "Change cursor line number on mode change",
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local link_hl = function(link)
      vim.api.nvim_set_hl(0, "CursorLineNr", { link = link })
    end

    if mode == "i" then
      link_hl("CursorLineNrInsert")
    elseif mode == "n" then
      link_hl("CursorLineNrNormal")
    elseif mode == "v" then
      link_hl("CursorLineNrVisual")
    end
  end,
})
