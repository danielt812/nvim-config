vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  desc = "Format on save",
  pattern = { "*.lua", "*.js", "*.jsx", "*.json", "*.jsonc", "*.py", "*.scss", "*.css", "*.zsh", "*.sh" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

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

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("yank_position", { clear = true }),
  desc = "Prevent cursor moving after yank",
  callback = function()
    if vim.v.event.operator == "y" and vim.b.cursor_pre_yank then
      vim.api.nvim_win_set_cursor(0, vim.b.cursor_pre_yank)
      vim.b.cursor_pre_yank = nil
    end
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
  callback = function(args)
    local file = args.file
    local max_filesize = 1024 * 200 -- 200 KB threshold, adjust as needed
    local ok, stats = pcall(vim.loop.fs_stat, file)
    if ok and stats and stats.size > max_filesize then
      vim.schedule(function()
        -- Disable features known to slow down large files
        -- vim.cmd("syntax off")
        -- vim.cmd("filetype off")
        -- vim.opt_local.foldmethod = "manual"

        if vim.treesitter.highlighter then
          vim.treesitter.stop(args.buf)
        end

        -- Optional: disable LSP
        -- for _, client in pairs(vim.lsp.get_clients({ bufnr = args.buf })) do
        --   vim.lsp.buf_detach_client(args.buf, client.id)
        -- end

        vim.bo.swapfile = false
        vim.bo.undofile = false
        vim.bo.bufhidden = "unload"

        vim.notify("Large file detected — disabling Tree-sitter", vim.log.levels.WARN)
      end)

      vim.defer_fn(function()
        vim.treesitter.start(args.buf)
      end, 3000)
    end
  end,
})

-- local term = vim.api.nvim_replace_termcodes("<C-z>", true, true, true)
-- vim.opt.wildmenu = true
-- vim.opt.wildoptions = "pum,fuzzy"
-- vim.opt.wildmode = "noselect:lastused,full"
-- vim.opt.wildcharm = vim.fn.char2nr(term)

-- -- vim.keymap.set("c", "<Up>", "<End><C-U><Up>", { silent = true })
-- -- vim.keymap.set("c", "<Down>", "<End><C-U><Down>", { silent = true })

-- vim.api.nvim_create_autocmd("CmdlineChanged", {
--   group = vim.api.nvim_create_augroup("wildmenu_group", { clear = true }),
--   pattern = ":",
--   callback = function()
--     local cmdline = vim.fn.getcmdline()
--     local curpos = vim.fn.getcmdpos()
--     local last_char = cmdline:sub(-1)

--     if
--       curpos == #cmdline + 1
--       and vim.fn.pumvisible() == 0
--       and last_char:match("[%w%/%: ]")
--       and not cmdline:match("^%d+$")
--     then
--       vim.opt.eventignore:append("CmdlineChanged")
--       vim.api.nvim_feedkeys(term, "ti", false)
--       vim.schedule(function()
--         vim.opt.eventignore:remove("CmdlineChanged")
--       end)
--     end
--   end,
-- })
