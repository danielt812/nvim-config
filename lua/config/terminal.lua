---@class Terminal
---@field layout "horizontal"|"vertical"|"full"
---@field cmd string|nil
---@field buf integer|nil
---@field height integer|nil remembered across horizontal splits
---@field width integer|nil remembered across vertical splits
---@field prev_buf integer|nil restored when full terminal is hidden or exits
---@field prev_showtabline integer|nil
---@field job_id integer|nil

---@type table<string, Terminal>
local terms = {}

local function find_win(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then return win end
  end
end

local function open_split(term)
  if term.layout == "horizontal" then
    vim.cmd("botright split")
    vim.api.nvim_win_set_height(0, term.height or math.ceil(vim.o.lines * 0.2))
  elseif term.layout == "vertical" then
    vim.cmd("rightbelow vsplit")
    vim.api.nvim_win_set_width(0, term.width or math.ceil(vim.o.columns * 0.5))
  end
end

-- Use keepalt to avoid polluting the alternate buffer (<C-^>)
local function switch_buf(win, buf)
  vim.api.nvim_win_call(win, function() vim.cmd("keepalt buffer " .. buf) end)
end

local function fallback_buf(win)
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and vim.api.nvim_buf_is_valid(alt) and vim.bo[alt].buflisted then
    switch_buf(win, alt)
  else
    vim.api.nvim_win_call(win, open_starter)
  end
end

local function hide(term, win)
  if term.layout == "horizontal" then
    term.height = vim.api.nvim_win_get_height(win)
    vim.api.nvim_win_close(win, false)
  elseif term.layout == "vertical" then
    term.width = vim.api.nvim_win_get_width(win)
    vim.api.nvim_win_close(win, false)
  elseif term.layout == "full" then
    vim.o.showtabline = term.prev_showtabline or 1
    local prev = term.prev_buf
    if prev and prev ~= term.buf and vim.api.nvim_buf_is_valid(prev) then
      switch_buf(win, prev)
    else
      fallback_buf(win)
    end
  end
end

local function show(term)
  if term.layout == "full" then
    term.prev_buf = vim.api.nvim_get_current_buf()
    term.prev_showtabline = vim.o.showtabline
    vim.o.showtabline = 0
    switch_buf(0, term.buf)
    vim.schedule(function()
      local win = find_win(term.buf)
      if not win then return end
      local job_id
      vim.api.nvim_buf_call(term.buf, function() job_id = vim.b.terminal_job_id end)
      if job_id then
        vim.fn.jobresize(job_id, vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win))
        if term.cmd then vim.fn.chansend(job_id, "\x0c") end
      end
    end)
  else
    open_split(term)
    switch_buf(0, term.buf)
  end
  vim.schedule(function() vim.cmd("startinsert") end)
end

local function create(term)
  if term.layout == "full" then
    term.prev_buf = vim.api.nvim_get_current_buf()
    term.prev_showtabline = vim.o.showtabline
    vim.o.showtabline = 0
  else
    open_split(term)
  end
  local buf = vim.api.nvim_create_buf(false, false)
  switch_buf(0, buf)
  local on_exit = term.cmd
      and function(_, code)
        local name = term.name or term.cmd
        local stopped = code == 130 or code == 143 -- SIGINT / SIGTERM
        local msg = stopped and ("Stopped: " .. name)
          or code == 0 and ("Finished: " .. name)
          or ("Failed (" .. code .. "): " .. name)
        local level = (code == 0 or stopped) and vim.log.levels.INFO or vim.log.levels.ERROR
        local failed = code ~= 0 and not stopped
        vim.schedule(function()
          vim.notify(msg, level)
          if failed and term.buf and vim.api.nvim_buf_is_valid(term.buf) and not find_win(term.buf) then show(term) end
        end)
      end
    or nil
  term.job_id = vim.fn.jobstart(term.cmd or vim.o.shell, { term = true, cwd = vim.fn.getcwd(), on_exit = on_exit })
  term.buf = buf
  vim.bo[buf].buflisted = false
  vim.cmd("startinsert")
end

local function restore_full(term)
  local buf = term.buf
  local win = find_win(buf)
  term.buf = nil
  vim.o.showtabline = term.prev_showtabline or 1
  if not win then return end
  local prev = term.prev_buf
  if prev and prev ~= buf and vim.api.nvim_buf_is_valid(prev) then
    switch_buf(win, prev)
  else
    fallback_buf(win)
  end
end

local function toggle_term(name, opts)
  local term = terms[name]
  if not term then
    term = vim.tbl_extend("force", { layout = "horizontal", name = name }, opts or {})
    terms[name] = term
  end

  if not (term.buf and vim.api.nvim_buf_is_valid(term.buf)) then
    create(term)
    return
  end

  local win = find_win(term.buf)
  if win then
    hide(term, win)
  else
    show(term)
  end
end

local last_term_name = nil

local function toggle_smart()
  local buf = vim.api.nvim_get_current_buf()
  for name, term in pairs(terms) do
    if term.buf and term.buf == buf then
      local win = find_win(term.buf)
      if win then hide(term, win) end
      last_term_name = name
      return
    end
  end

  if
    last_term_name
    and terms[last_term_name]
    and terms[last_term_name].buf
    and vim.api.nvim_buf_is_valid(terms[last_term_name].buf)
  then
    show(terms[last_term_name])
  else
    vim.cmd("Term full")
  end
end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function term_open_cb()
  vim.bo.filetype = "terminal"
  vim.wo.winhighlight = "Normal:Terminal"
  vim.cmd("startinsert")
end

local function term_close_cb(args)
  vim.wo.winhighlight = ""
  for _, term in pairs(terms) do
    if term.buf == args.buf then
      if term.layout == "full" then
        vim.schedule(function() restore_full(term) end)
      else
        term.buf = nil
      end
      break
    end
  end
end

local function buf_win_enter_cb()
  local win = vim.api.nvim_get_current_win()
  local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
  if vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  elseif not is_float then
    vim.wo.winhighlight = ""
  end
end

local function colorscheme_cb()
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
end

local function win_resized_cb()
  for _, term in pairs(terms) do
    if not (term.buf and vim.api.nvim_buf_is_valid(term.buf)) then goto continue end
    local win = find_win(term.buf)
    if win then
      if term.layout == "horizontal" then term.height = vim.api.nvim_win_get_height(win) end
      if term.layout == "vertical" then term.width = vim.api.nvim_win_get_width(win) end
    end
    ::continue::
  end
end

local function quit_pre_cb()
  for _, term in pairs(terms) do
    if term.job_id then pcall(vim.fn.jobstop, term.job_id) end
  end
end

local group = vim.api.nvim_create_augroup("terminal_manager", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*" },
  group = group,
  desc = "Set up terminal windows",
  callback = term_open_cb,
})

vim.api.nvim_create_autocmd("TermClose", {
  pattern = { "term://*" },
  group = group,
  desc = "Clean up on terminal close",
  callback = term_close_cb,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  desc = "Auto insert for terminals, clear winhighlight for normal buffers",
  callback = buf_win_enter_cb,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "*" },
  group = group,
  desc = "Set terminal ANSI palette",
  callback = colorscheme_cb,
})

vim.api.nvim_create_autocmd("WinResized", {
  group = group,
  desc = "Remember split terminal size after manual resize",
  callback = win_resized_cb,
})

vim.api.nvim_create_autocmd("QuitPre", {
  group = group,
  desc = "Kill all managed terminal jobs on quit",
  callback = quit_pre_cb,
})

-- #############################################################################
-- #                                 Task Picker                               #
-- #############################################################################

local function rg_has_match(glob)
  local result = vim.fn.systemlist({ "rg", "--files", "--glob", glob, "--max-count", "1", vim.fn.getcwd() })
  return #result > 0
end

local function get_package_scripts()
  local root = vim.fs.root(vim.api.nvim_buf_get_name(0), "package.json")
  if not root then return {} end
  local path = root .. "/package.json"
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.fn.json_decode, content)
  if not ok or type(decoded) ~= "table" or type(decoded.scripts) ~= "table" then return {} end
  local tasks = {}
  for name, _ in pairs(decoded.scripts) do
    table.insert(tasks, { label = "npm: " .. name, cmd = "cd " .. root .. " && npm run " .. name })
  end
  table.sort(tasks, function(a, b) return a.label < b.label end)
  return tasks
end

local function get_make_targets()
  local root = vim.fs.root(vim.api.nvim_buf_get_name(0), "Makefile")
  if not root then return {} end
  local path = root .. "/Makefile"
  local f = io.open(path, "r")
  if not f then return {} end
  local tasks = {}
  for line in f:lines() do
    local target = line:match("^([%w_%-]+)%s*:")
    if target and target ~= ".PHONY" then
      table.insert(tasks, { label = "make: " .. target, cmd = "cd " .. root .. " && make " .. target })
    end
  end
  f:close()
  table.sort(tasks, function(a, b) return a.label < b.label end)
  return tasks
end

local function get_scss_watch()
  if not rg_has_match("*.scss") then return {} end
  local cwd = vim.fn.getcwd()
  return { { label = "sass: watch", cmd = "sass --watch --no-source-map " .. cwd .. ":" .. cwd } }
end

local function get_running_tasks()
  local running = {}
  for name, term in pairs(terms) do
    if term.buf and vim.api.nvim_buf_is_valid(term.buf) and term.cmd then table.insert(running, name) end
  end
  table.sort(running)
  return running
end

local function select_task(prompt, callback)
  local running = get_running_tasks()
  if #running == 0 then
    vim.notify("No running tasks", vim.log.levels.WARN)
    return
  end
  if #running == 1 then
    callback(running[1])
    return
  end
  vim.ui.select(running, { prompt = prompt }, function(choice)
    if choice then callback(choice) end
  end)
end

local function kill_task()
  select_task("Kill task", function(name)
    local term = terms[name]
    if not term then return end
    if term.job_id then pcall(vim.fn.jobstop, term.job_id) end
    if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      local win = find_win(term.buf)
      if win then vim.api.nvim_win_close(win, true) end
      vim.api.nvim_buf_delete(term.buf, { force = true })
    end
    term.buf = nil
    term.job_id = nil
    vim.notify("Killed: " .. name)
  end)
end

local function open_task()
  select_task("Open task", function(name)
    local term = terms[name]
    if not term then return end
    local win = find_win(term.buf)
    if not win then show(term) end
  end)
end

local runners = {
  python = "python3 %s",
  sh = "sh %s",
  bash = "bash %s",
  zsh = "zsh %s",
  javascript = "node %s",
  typescript = "npx ts-node %s",
  go = "go run %s",
  lua = "lua %s",
  rust = "cargo run",
}

local watch_augroup = vim.api.nvim_create_augroup("watch_file", { clear = true })

local function run_term_name() return "run: " .. vim.fn.expand("%:t") end

local function run_cmd()
  local runner = runners[vim.bo.filetype]
  if not runner then return nil end
  return runner:format(vim.fn.expand("%:."))
end

local function send_cmd(term, cmd)
  vim.fn.chansend(term.job_id, cmd .. "\n")
  local win = find_win(term.buf)
  if win then
    local line_count = vim.api.nvim_buf_line_count(term.buf)
    vim.api.nvim_win_set_cursor(win, { line_count, 0 })
  end
end

local function run_file()
  local cmd = run_cmd()
  if not cmd then
    vim.notify("No runner for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  local name = run_term_name()
  local term = terms[name]
  local prev_win = vim.api.nvim_get_current_win()

  -- Re-run in existing terminal
  if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) and term.job_id then
    if not find_win(term.buf) then show(term) end
    send_cmd(term, cmd)
    vim.cmd("stopinsert")
    vim.api.nvim_set_current_win(prev_win)
    return
  end

  -- Create new shell terminal and send command
  toggle_term(name, { layout = "horizontal" })
  vim.schedule(function()
    local t = terms[name]
    if t and t.job_id then send_cmd(t, cmd) end
    vim.cmd("stopinsert")
    vim.api.nvim_set_current_win(prev_win)
  end)
end

local function watch_file()
  local cmd = run_cmd()
  if not cmd then
    vim.notify("No runner for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  local src_buf = vim.api.nvim_get_current_buf()
  local name = run_term_name()
  local term = terms[name]

  -- Toggle off if already watching
  if vim.b[src_buf].watching then
    vim.api.nvim_clear_autocmds({ group = watch_augroup, buffer = src_buf })
    vim.b[src_buf].watching = false
    vim.notify("Stopped watching: " .. vim.fn.expand("%:t"))
    return
  end

  local prev_win = vim.api.nvim_get_current_win()

  -- Reuse existing run terminal or create one
  if not (term and term.buf and vim.api.nvim_buf_is_valid(term.buf) and term.job_id) then
    toggle_term(name, { layout = "horizontal" })
    vim.schedule(function()
      local t = terms[name]
      if t and t.job_id then send_cmd(t, cmd) end
      vim.cmd("stopinsert")
      vim.api.nvim_set_current_win(prev_win)
    end)
  else
    if not find_win(term.buf) then show(term) end
    send_cmd(term, cmd)
    vim.cmd("stopinsert")
    vim.api.nvim_set_current_win(prev_win)
  end

  vim.b[src_buf].watching = true

  -- Re-run on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = watch_augroup,
    buffer = src_buf,
    desc = "Re-run file on save",
    callback = function()
      if not vim.b[src_buf].watching then return true end
      local t = terms[name]
      if not t or not t.job_id then return true end
      send_cmd(t, cmd)
    end,
  })
end

local function get_live_server()
  if not rg_has_match("*.html") then return {} end
  if vim.fn.executable("live-server") ~= 1 then return {} end
  return { { label = "live-server", cmd = "live-server" } }
end

local function run_task()
  local tasks = {}
  vim.list_extend(tasks, get_package_scripts())
  vim.list_extend(tasks, get_make_targets())
  vim.list_extend(tasks, get_scss_watch())
  vim.list_extend(tasks, get_live_server())

  if #tasks == 0 then
    vim.notify("No tasks found", vim.log.levels.WARN)
    return
  end

  local labels = vim.tbl_map(function(t) return t.label end, tasks)
  vim.ui.select(labels, { prompt = "Run task" }, function(choice)
    if not choice then return end
    for _, task in ipairs(tasks) do
      if task.label == choice then
        toggle_term(choice, { layout = "horizontal", cmd = task.cmd })
        vim.cmd("stopinsert")
        vim.cmd("wincmd p")
        toggle_term(choice, { layout = "horizontal" })
        vim.notify("Running: " .. choice)
        return
      end
    end
  end)
end

-- #############################################################################
-- #                                 Keymaps                                   #
-- #############################################################################

-- stylua: ignore start
local claude     = function() toggle_term("claude",     { layout = "full", cmd = "claude" }) end
local lazygit    = function() toggle_term("lazygit",    { layout = "full", cmd = "lazygit" }) end
local delta      = function() toggle_term("delta",      { layout = "full", cmd = "git diff | delta --diff-so-fancy --side-by-side --line-numbers" }) end
local vertical   = function() toggle_term("vertical",   { layout = "vertical"   }) end
local horizontal = function() toggle_term("horizontal", { layout = "horizontal" }) end
local full       = function() toggle_term("full",       { layout = "full"       }) end

-- stylua: ignore start
vim.keymap.set({ "n", "t" }, "<C-t>",  full,         { desc = "Full Terminal" })
vim.keymap.set({ "n", "t" }, "<C-s>",  vertical,     { desc = "Split Terminal" })
vim.keymap.set({ "n", "t" }, "<C-g>",  lazygit,      { desc = "Lazygit" })
vim.keymap.set({ "n", "t" }, "<C-e>",  claude,       { desc = "Claude Code" })
vim.keymap.set({ "n", "t" }, "\\t",    toggle_smart, { desc = "Toggle 'terminal'" })
vim.keymap.set({ "n", "t" }, "<C-\\>", toggle_smart, { desc = "Toggle terminal" })
-- stylua: ignore end

-- Ctrl-HJKL Window Navigation ------------------------------------------------
local tui_cmds = { "lazygit", "claude" }

local function is_tui_term()
  local buf = vim.api.nvim_get_current_buf()
  for _, term in pairs(terms) do
    if term.buf == buf and term.cmd then
      for _, tui in ipairs(tui_cmds) do
        if term.cmd:find(tui, 1, true) then return true end
      end
    end
  end
  return false
end

local function term_wincmd(key)
  return function()
    if is_tui_term() then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-" .. key .. ">", true, false, true), "n", false)
    else
      vim.cmd("stopinsert")
      vim.cmd("wincmd " .. key)
    end
  end
end

vim.keymap.set("t", "<C-h>", term_wincmd("h"), { desc = "Move to left window" })
vim.keymap.set("t", "<C-j>", term_wincmd("j"), { desc = "Move to below window" })
vim.keymap.set("t", "<C-k>", term_wincmd("k"), { desc = "Move to above window" })
vim.keymap.set("t", "<C-l>", term_wincmd("l"), { desc = "Move to right window" })

vim.keymap.set("n", "<leader>gg", lazygit, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gf", delta,   { desc = "Delta" })

vim.keymap.set("n", "<leader>tt", run_task, { desc = "Run task" })
vim.keymap.set("n", "<leader>tf", run_file,   { desc = "Run file" })
vim.keymap.set("n", "<leader>tw", watch_file, { desc = "Watch file" })

vim.keymap.set("n", "<leader>to", open_task, { desc = "Open" })
vim.keymap.set("n", "<leader>tk", kill_task, { desc = "Kill" })
-- stylua: ignore end

-- #############################################################################
-- #                               User Commands                               #
-- #############################################################################

-- stylua: ignore start
local term_commands = {
  horizontal = horizontal,
  vertical   = vertical,
  full       = full,
  lazygit    = lazygit,
  delta      = delta,
  toggle     = toggle_smart,
}
-- stylua: ignore end

vim.api.nvim_create_user_command("Term", function(opts)
  local fn = term_commands[opts.args]
  if fn then fn() end
end, { nargs = 1, complete = function() return vim.tbl_keys(term_commands) end })
