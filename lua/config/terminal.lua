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
    vim.api.nvim_win_set_height(0, term.height or 10)
  elseif term.layout == "vertical" then
    vim.cmd("rightbelow vsplit")
    vim.api.nvim_win_set_width(0, term.width or math.floor(vim.o.columns * 0.5))
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
  term.job_id = vim.fn.jobstart(term.cmd or vim.o.shell, { term = true, cwd = vim.fn.getcwd() })
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
        vim.fn.chansend(job_id, "\x0c")
      end
    end)
  else
    open_split(term)
    switch_buf(0, term.buf)
  end
  vim.cmd("startinsert")
end

local function toggle(name, opts)
  local term = terms[name]
  if not term then
    term = vim.tbl_extend("force", { layout = "horizontal" }, opts or {})
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
  if not is_float and vim.bo.buftype ~= "terminal" then vim.wo.winhighlight = "" end
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

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*" },
  group = group,
  desc = "Clear winhighlight when a normal buffer enters a window",
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

local function get_package_scripts()
  local path = vim.fn.getcwd() .. "/package.json"
  local f = io.open(path, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.fn.json_decode, content)
  if not ok or type(decoded) ~= "table" or type(decoded.scripts) ~= "table" then return {} end
  local tasks = {}
  for name, _ in pairs(decoded.scripts) do
    table.insert(tasks, { label = "npm: " .. name, cmd = "npm run " .. name })
  end
  table.sort(tasks, function(a, b) return a.label < b.label end)
  return tasks
end

local function get_make_targets()
  local path = vim.fn.getcwd() .. "/Makefile"
  local f = io.open(path, "r")
  if not f then return {} end
  local tasks = {}
  for line in f:lines() do
    local target = line:match("^([%w_%-]+)%s*:")
    if target and target ~= ".PHONY" then
      table.insert(tasks, { label = "make: " .. target, cmd = "make " .. target })
    end
  end
  f:close()
  table.sort(tasks, function(a, b) return a.label < b.label end)
  return tasks
end

local function run_task()
  local tasks = {}
  vim.list_extend(tasks, get_package_scripts())
  vim.list_extend(tasks, get_make_targets())

  if #tasks == 0 then
    vim.notify("No tasks found", vim.log.levels.WARN)
    return
  end

  local labels = vim.tbl_map(function(t) return t.label end, tasks)
  vim.ui.select(labels, { prompt = "Run task" }, function(choice)
    if not choice then return end
    for _, task in ipairs(tasks) do
      if task.label == choice then
        toggle(choice, { layout = "horizontal", cmd = task.cmd })
        return
      end
    end
  end)
end

-- #############################################################################
-- #                                 Keymaps                                   #
-- #############################################################################

-- stylua: ignore start
local lazygit   = function() toggle("lazygit",    { layout = "full", cmd = "lazygit" }) end
local delta     = function() toggle("delta",      { layout = "full", cmd = "git diff | delta --diff-so-fancy --side-by-side --line-numbers" }) end
local vertical  = function() toggle("vertical",   { layout = "vertical"   }) end
local horizontal= function() toggle("horizontal", { layout = "horizontal" }) end
local full      = function() toggle("full",       { layout = "full"       }) end

vim.keymap.set({ "n", "t" }, "<C-t>",      full,       { desc = "Full Terminal" })
vim.keymap.set({ "n", "t" }, "<C-g>",      lazygit,    { desc = "Lazygit" })
vim.keymap.set("n",          "<C-\\>",     vertical,   { desc = "Vertical Terminal" })

vim.keymap.set("n",          "<leader>gg", lazygit,    { desc = "Lazygit" })
vim.keymap.set("n",          "<leader>gd", delta,      { desc = "Delta" })
vim.keymap.set("n",          "<leader>tc", full,       { desc = "Full Terminal" })
vim.keymap.set("n",          "<leader>t|", vertical,   { desc = "Vertical Terminal" })
vim.keymap.set("n",          "<leader>t-", horizontal, { desc = "Horizontal Terminal" })
vim.keymap.set("n",          "<leader>tt", run_task,   { desc = "Run task" })
-- stylua: ignore end
