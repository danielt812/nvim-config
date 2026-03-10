local git = require("mini.git")
local colors = require("mini.colors")
local util_hl = require("utils.highlight")

git.setup()

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
local blame     = function() vim.cmd("vertical Git blame --porcelain -- %") end
local log_file  = function() vim.cmd("Git log --follow -- %") end
local log_repo  = function() vim.cmd("Git log --oneline") end
local function patch_log() vim.cmd("Git log --follow --patch -- %") end

vim.keymap.set("n", "<leader>gb", blame,     { desc = "Blame" })
vim.keymap.set("n", "<leader>gl", log_file,  { desc = "Log (file)" })
vim.keymap.set("n", "<leader>gL", log_repo,  { desc = "Log (repo)" })
vim.keymap.set("n", "<leader>gp", patch_log, { desc = "Patch log (file)" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

-- stylua: ignore
local ns = {
  conflict = vim.api.nvim_create_namespace("mini_git_conflict"),
  blame    = vim.api.nvim_create_namespace("mini_git_blame"),
  status   = vim.api.nvim_create_namespace("mini_git_status"),
}

local group = vim.api.nvim_create_augroup("mini_git", { clear = true })

local function darken_bg(hl_name, amount)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
  if not hl.bg then return end
  local oklch = colors.convert(string.format("#%06x", hl.bg), "oklch")
  oklch.l = math.max(0, oklch.l - amount)
  return colors.convert(oklch, "hex", { gamut_clip = "chroma" })
end

local function gen_conflict_palette()
  local sk_fg = (vim.api.nvim_get_hl(0, { name = "SpecialKey", link = false })).fg
  for _, cfg in ipairs({
    {
      src = "DiffText",
      header = "ConflictOursHeader",
      marker = "ConflictMarker_Ours",
      label = "ConflictLabel_Ours",
      virt = "ConflictOursVirt",
    },
    {
      src = "DiffAdd",
      header = "ConflictTheirsHeader",
      marker = "ConflictMarker_Theirs",
      label = "ConflictLabel_Theirs",
      virt = "ConflictTheirsVirt",
    },
  }) do
    local darker = darken_bg(cfg.src, 2)
    if darker then
      vim.api.nvim_set_hl(0, cfg.header, { fg = sk_fg, bg = darker, bold = true })
      util_hl.merge_hl("SpecialKey", cfg.header, cfg.marker)
      util_hl.merge_hl("Fg", cfg.header, cfg.label)
      util_hl.merge_hl("Comment", cfg.header, cfg.virt)
    end
  end
end

local function gen_blame_palette(count)
  local dark = vim.o.background == "dark"
  local lightness = dark and 75 or 45
  local chroma = dark and 20 or 18
  local uv = vim.uv or vim.loop
  local offset = (uv.hrtime() % 360)
  local palette = {}
  for i = 1, count do
    -- Go to opposite side of color wheel so adjacent commits contrast more
    local hue = (offset + (i - 1) * 137.508) % 360
    palette[i] = colors.convert({ l = lightness, c = chroma, h = hue }, "hex")
  end
  return palette
end

local function gen_hl_groups()
  vim.api.nvim_set_hl(0, "MiniGitBlameHash", { link = "Comment" })
  vim.api.nvim_set_hl(0, "MiniGitBlameUncommitted", { link = "Conceal" })
end

gen_hl_groups() -- Call this now if colorscheme was already set

vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", group = group, callback = gen_hl_groups })

-- #############################################################################
-- #                                 Conflict                                  #
-- #############################################################################

local function find_conflicts(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  local ours, base, theirs = {}, {}, {}
  local conflicts = {}
  -- stylua: ignore
  for ln, line in ipairs(lines) do
    if vim.startswith(line, "<<<<<<<") then ours[1] = ln end
    if vim.startswith(line, "|||||||") then base[1] = ln end
    if vim.startswith(line, "=======") then ours[2], base[2], theirs[1] = ln, ln, ln end
    if vim.startswith(line, ">>>>>>>") then
      theirs[2] = ln
      if ours[1] and ours[2] and theirs[1] and theirs[2] then
        table.insert(conflicts, { ours, (base[1] and base[2]) and base or nil, theirs })
      end
      ours, base, theirs = {}, {}, {}
    end
  end
  return conflicts
end

local function highlight_conflicts(buf)
  if type(buf) == "table" then buf = buf.buf end
  local conflicts = find_conflicts(buf)
  vim.b[buf].minigit_conflicts = conflicts
  vim.api.nvim_buf_clear_namespace(buf, ns.conflict, 0, -1)
  if #conflicts > 0 then gen_conflict_palette() end

  local extmark = function(line, col, opts) vim.api.nvim_buf_set_extmark(buf, ns.conflict, line, col, opts) end

  local function set_marker_hl(ln, bg_hl, marker_hl, label_hl)
    local line = vim.api.nvim_buf_get_lines(buf, ln - 1, ln, true)[1] or ""
    local marker_end = line:find(" ") or #line
    extmark(ln - 1, 0, { end_row = ln, hl_group = bg_hl, hl_eol = true, priority = 100 })
    extmark(ln - 1, 0, { end_col = marker_end, hl_group = marker_hl, priority = 200 })
    if marker_end < #line then extmark(ln - 1, marker_end, { end_col = #line, hl_group = label_hl, priority = 200 }) end
  end
  for _, conflict in ipairs(conflicts) do
    local ours, base, theirs = unpack(conflict)

    set_marker_hl(ours[1], "ConflictOursHeader", "ConflictMarker_Ours", "ConflictLabel_Ours")
    set_marker_hl(theirs[2], "ConflictTheirsHeader", "ConflictMarker_Theirs", "ConflictLabel_Theirs")
    extmark(ours[1] - 1, 0, { virt_text = { { "(Ours)", "ConflictOursVirt" } }, virt_text_pos = "eol" })
    extmark(ours[1], 0, { end_row = ours[2] - 1, hl_group = "DiffText", hl_eol = true })
    extmark(ours[2] - 1, 0, { line_hl_group = "SpecialKey" })
    extmark(theirs[1], 0, { end_row = theirs[2] - 1, hl_group = "DiffAdd", hl_eol = true })
    extmark(theirs[2] - 1, 0, { virt_text = { { "(Theirs)", "ConflictTheirsVirt" } }, virt_text_pos = "eol" })
    if type(base) == "table" then
      extmark(base[1] - 1, 0, { end_row = base[2] - 1, hl_group = "DiffDelete", hl_eol = true })
    end

    -- stylua: ignore
    local hint_line = {
      { "co ",     "Keyword" }, { "ours",   "Comment" }, { " | ", "NonText" },
      { "ct ",     "Keyword" }, { "theirs", "Comment" }, { " | ", "NonText" },
      { "cb ",     "Keyword" }, { "both",   "Comment" }, { " | ", "NonText" },
      { "cn ",     "Keyword" }, { "none",   "Comment" }, { " | ", "NonText" },
      { "cd ",     "Keyword" }, { "diff",   "Comment" }, { " | ", "NonText" },
      { " ]x [x ", "Keyword" }, { "nav",    "Comment" },
    }
    extmark(theirs[2] - 1, 0, { virt_lines = { hint_line } })
  end
end

local function get_conflict_lines(from, to) return vim.api.nvim_buf_get_lines(0, from - 1, to - 1, true) end

-- #############################################################################
-- #                                   Blame                                   #
-- #############################################################################

local function pad_right(str, width)
  local pad = width - vim.fn.strwidth(str)
  if pad <= 0 then return str end
  return str .. string.rep(" ", pad)
end

--- Format unix timestamp
---@param timestamp integer Unix timestamp (seconds since epoch)
---@param fmt string os.date format string (e.g. `"%Y-%m-%d"`)
---@param rel? boolean|integer true = always relative, N = relative within N days then fallback to fmt
---@return string
local function format_time(timestamp, fmt, rel)
  if not rel then return tostring(os.date(fmt, timestamp)) end
  local diff = os.time() - timestamp
  local days = math.floor(diff / 86400)
  if type(rel) == "number" and days >= rel then return tostring(os.date(fmt, timestamp)) end
  local function ago(n, unit) return n .. (n == 1 and " " .. unit .. " ago" or " " .. unit .. "s ago") end
  if diff < 60 then return ago(diff, "second") end
  if diff < 3600 then return ago(math.floor(diff / 60), "minute") end
  if diff < 86400 then return ago(math.floor(diff / 3600), "hour") end
  if diff < 2592000 then return ago(days, "day") end
  if diff < 31536000 then return ago(math.floor(diff / 2592000), "month") end
  return ago(math.floor(diff / 31536000), "year")
end

--- Format parsed blame data into display lines.
--- @param data {sha: string, sha_short: string, date: string, author: string}[]
--- @param skip_consecutive boolean? Replace consecutive lines with the same sha with "┃"
--- @return string[]
local function format_blame(data, skip_consecutive)
  local max_date = 0
  for _, entry in ipairs(data) do
    if entry.author ~= "Not Committed Yet" then max_date = math.max(max_date, #entry.date) end
  end
  local formatted, prev_sha = {}, nil
  for _, entry in ipairs(data) do
    if skip_consecutive and entry.sha == prev_sha then
      table.insert(formatted, "┃")
    elseif entry.author == "Not Committed Yet" then
      table.insert(formatted, "Not Committed Yet")
    else
      table.insert(formatted, string.format("%s %s %s", entry.sha_short, pad_right(entry.date, max_date), entry.author))
    end
    prev_sha = entry.sha
  end
  return formatted
end

local function parse_porcelain(lines)
  local commits, parsed = {}, {}
  local i = 1
  while i <= #lines do
    local sha, _, final = lines[i]:match("^(%x+) (%d+) (%d+)")
    if not sha then break end
    if not commits[sha] then
      commits[sha] = {}
      i = i + 1
      while i <= #lines and not lines[i]:match("^\t") do
        local key, val = lines[i]:match("^(%S+)%s?(.*)")
        if key then commits[sha][key] = val end
        i = i + 1
      end
    else
      i = i + 1
      while i <= #lines and not lines[i]:match("^\t") do
        i = i + 1
      end
    end
    local c = commits[sha]
    table.insert(parsed, {
      sha = sha,
      sha_short = sha:sub(1, 7),
      author = c.author or "",
      date = c["author-time"] and format_time(c["author-time"], "%Y-%m-%d", 10) or "",
      line = tonumber(final),
    })
    i = i + 1
  end
  return parsed
end
-- #############################################################################
-- #                                 Callbacks                                 #
-- #############################################################################

local function conflict_cb(args)
  local buf = args.buf
  local in_progress = (vim.b[buf or 0].minigit_summary or {}).in_progress
  local conflicting = in_progress
    and (in_progress:find("merge") or in_progress:find("cherry") or in_progress:find("rebase"))

  if conflicting then
    if vim.b[buf].minigit_conflicts then return end

    vim.diagnostic.enable(false, { bufnr = buf })
    highlight_conflicts(buf)

    vim.api.nvim_create_autocmd("ModeChanged", {
      pattern = "i:*",
      group = group,
      callback = function(a)
        if a.buf == buf then highlight_conflicts(buf) end
      end,
    })

    vim.api.nvim_create_autocmd("TextChanged", {
      group = group,
      buffer = buf,
      callback = highlight_conflicts,
    })

    local function with_conflict(fn)
      return function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        for _, conflict in ipairs(vim.b.minigit_conflicts or {}) do
          local ours, _, theirs = unpack(conflict)
          if lnum >= ours[1] and lnum <= theirs[2] then return fn(conflict) end
        end
      end
    end

    local function replace(conflict, lines)
      local ours, _, theirs = unpack(conflict)
      vim.api.nvim_buf_set_lines(0, ours[1] - 1, theirs[2], true, lines)
      vim.api.nvim_win_set_cursor(0, { ours[1], 0 })
    end

    local function conflict_search(start, flags)
      local line = type(start) == "number" and start or vim.fn.line(start)
      local saved = vim.fn.getpos(".")
      vim.fn.cursor(line, 0)
      if vim.fn.search("^<<<<<<< ", flags or "") == 0 or vim.fn.line(".") == saved[2] then
        vim.fn.cursor(saved[2], saved[3])
      end
    end

    local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc }) end
    local function base_or(base, fallback) return type(base) == "table" and base[1] or fallback end

    -- stylua: ignore start
    local checkout_ours = with_conflict(function(c)
      local ours, base = c[1], c[2]
      replace(c, get_conflict_lines(ours[1] + 1, base_or(base, ours[2])))
    end)

    local checkout_theirs = with_conflict(function(c)
      replace(c, get_conflict_lines(c[3][1] + 1, c[3][2]))
    end)

    local checkout_both = with_conflict(function(c)
      local ours, base, theirs = unpack(c)
      local r = get_conflict_lines(ours[1] + 1, base_or(base, ours[2]))
      vim.list_extend(r, get_conflict_lines(theirs[1] + 1, theirs[2]))
      replace(c, r)
    end)

    local checkout_none = with_conflict(function(c) replace(c, {}) end)

    local diff = with_conflict(function(c)
      local ours, base, theirs = unpack(c)
      local ours_lines = get_conflict_lines(ours[1] + 1, base_or(base, ours[2]))
      local theirs_lines = get_conflict_lines(theirs[1] + 1, theirs[2])
      vim.cmd("tabnew")
      local function scratch(lines)
        local b = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(b, 0, -1, true, lines)
        vim.bo[b].buftype, vim.bo[b].bufhidden = "nofile", "wipe"
        vim.cmd("diffthis")
      end
      scratch(ours_lines)
      vim.cmd("vnew")
      scratch(theirs_lines)
    end)

    local next_conflict = function() for _ = 1, vim.v.count1 do conflict_search(".", "") end end
    local prev_conflict = function() for _ = 1, vim.v.count1 do conflict_search(".", "b") end end
    local last_conflict = function() conflict_search("$", "bW") end
    local first_conflict = function() conflict_search(1, "cW") end

    map("co", checkout_ours,   "Checkout ours")
    map("ct", checkout_theirs, "Checkout theirs")
    map("cb", checkout_both,   "Checkout both")
    map("cn", checkout_none,   "Checkout none")
    map("cd", diff,            "Compare changes")
    map("]x", next_conflict,   "Next conflict")
    map("[x", prev_conflict,   "Prev conflict")
    map("]X", last_conflict,   "Last conflict")
    map("[X", first_conflict,  "First conflict")
    -- stylua: ignore end
  elseif vim.b[buf].minigit_conflicts then
    vim.diagnostic.enable(true, { bufnr = buf })
    vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
    vim.api.nvim_buf_clear_namespace(buf, ns.conflict, 0, -1)
    vim.b[buf].minigit_conflicts = nil
    for _, lhs in ipairs({ "co", "ct", "cb", "cn", "cc", "]x", "[x", "]X", "[X" }) do
      pcall(vim.keymap.del, "n", lhs, { buffer = buf })
    end
  end
end

local function blame_cb(event)
  if event.data.git_subcommand ~= "blame" or not event.data.cmd_input.mods:match("vertical") then return end
  vim.cmd("wincmd H")
  local win_src, buf, win = event.data.win_source, event.buf, event.data.win_stdout
  local extmark = function(ln, col, opts) vim.api.nvim_buf_set_extmark(buf, ns.blame, ln, col, opts) end

  -- stylua: ignore
  local settings = { number = false, relativenumber = false, winbar = "", signcolumn = "no", cursorbind = true, scrollbind = true, wrap = false }
  local saved = {}
  for key, val in pairs(settings) do
    saved[key] = vim.wo[win_src][key]
    vim.wo[win][key] = val
    vim.wo[win_src][key] = val
  end

  local blame_data = parse_porcelain(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
  local formatted = format_blame(blame_data, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)

  -- Highlights
  local unique_shas, sha_colors, color_idx = {}, {}, 0
  for _, data in ipairs(blame_data) do
    if not unique_shas[data.sha] and data.author ~= "Not Committed Yet" then
      unique_shas[data.sha] = true
      color_idx = color_idx + 1
    end
  end
  local palette = gen_blame_palette(color_idx)
  color_idx = 0
  for i, data in ipairs(blame_data) do
    local line = i - 1
    if not sha_colors[data.sha] and data.author ~= "Not Committed Yet" then
      color_idx = color_idx + 1
      sha_colors[data.sha] = color_idx
      local color = palette[color_idx]
      vim.api.nvim_set_hl(0, "MiniGitBlameDate" .. color_idx, { fg = color, italic = true })
      vim.api.nvim_set_hl(0, "MiniGitBlameAuthor" .. color_idx, { fg = color })
    end
    if data.author == "Not Committed Yet" then
      extmark(line, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameUncommitted" })
    elseif formatted[i] == "┃" then
      extmark(line, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameDate" .. sha_colors[data.sha] })
    else
      local ci = sha_colors[data.sha]
      local sha_end = #data.sha_short
      local date_end = sha_end + 1 + #data.date
      extmark(line, 0, { end_col = sha_end, hl_group = "MiniGitBlameHash" })
      extmark(line, sha_end + 1, { end_col = date_end, hl_group = "MiniGitBlameDate" .. ci })
      extmark(line, date_end + 1, { end_row = line, end_col = #formatted[i], hl_group = "MiniGitBlameAuthor" .. ci })
    end
  end

  -- Blame window options
  vim.wo[win].number = true
  vim.wo[win].winfixwidth = true
  vim.wo[win].winfixbuf = true
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
  vim.cmd("syncbind")

  -- Blame window width
  local max_len = 0
  for _, line in ipairs(formatted) do
    max_len = math.max(max_len, #line)
  end
  vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
  vim.api.nvim_win_set_width(win, max_len + math.max(vim.wo[win].numberwidth, #tostring(#formatted) + 1) + 2)

  -- Buffer keymaps --------------------------------------------------------------
  local function get_entry() return blame_data[vim.api.nvim_win_get_cursor(win)[1]] end
  local function map(key, fn, desc) vim.keymap.set("n", key, fn, { buffer = buf, desc = desc }) end
  local function with_commit(fn)
    local entry = get_entry()
    if entry and entry.author ~= "Not Committed Yet" then fn(entry.sha) end
  end

  -- stylua: ignore start
  local checkout = function() with_commit(function(sha) vim.cmd("Git checkout " .. sha) end) end
  local diff     = function() with_commit(function(sha) vim.cmd("Git diff " .. sha .. "^ " .. sha) end) end
  local files    = function() with_commit(function(sha) vim.cmd("Git show --name-status --format=fuller " .. sha) end) end
  local show     = function() with_commit(function(sha) vim.cmd("Git show " .. sha) end) end
  local stat     = function() with_commit(function(sha) vim.cmd("Git show --stat --summary --format=fuller " .. sha) end) end
  local yank     = function() with_commit(function(sha) vim.fn.setreg("+", sha) vim.notify("Yanked commit " .. sha) end) end

  map("c", checkout, "Checkout commit")
  map("d", diff,     "Diff commit")
  map("f", files,    "Show files in commit")
  map("s", show,     "Show commit")
  map("t", stat,     "Show commit stats")
  map("y", yank,     "Yank sha")
  -- stylua: ignore end

  local function close()
    if vim.api.nvim_win_is_valid(win_src) then
      -- stylua: ignore
      for opt, val in pairs(saved) do vim.wo[win_src][opt] = val end
    end
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  map("q", close, "Close blame")
  map("<esc>", close, "Close blame")

  -- stylua: ignore
  vim.api.nvim_create_autocmd({ "WinLeave", "BufWipeout" }, { buffer = buf, once = true, callback = close })
end

local function status_cb(event)
  if event.data.git_subcommand ~= "status" then return end
  local buf = event.buf
  vim.bo[buf].filetype = "git"
  vim.cmd("retab")
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local ln = i - 1
    local hl
    if line:match("^%s+modified:") then
      hl = "DiffChange"
    elseif line:match("^%s+new file:") then
      hl = "DiffAdd"
    elseif line:match("^%s+deleted:") then
      hl = "DiffDelete"
    elseif line:match("^%s+renamed:") then
      hl = "DiffChange"
    elseif line:match("^%s+%(use ") then
      hl = "Comment"
    elseif line:match("^Changes") or line:match("^Untracked") then
      hl = "Title"
    elseif line:match("^On branch") or line:match("^Your branch") or line:match("^HEAD") then
      hl = "Special"
    end
    if hl then vim.api.nvim_buf_set_extmark(buf, ns.status, ln, 0, { end_col = #line, hl_group = hl, priority = 1 }) end
  end
end

local function window_cb(event) vim.wo[event.data.win_stdout].winhighlight = "Normal:Terminal" end

-- stylua: ignore start
vim.api.nvim_create_autocmd("User", { pattern = "MiniGitCommandSplit", group = group, callback = window_cb })
vim.api.nvim_create_autocmd("User", { pattern = "MiniGitCommandSplit", group = group, callback = blame_cb })
vim.api.nvim_create_autocmd("User", { pattern = "MiniGitCommandSplit", group = group, callback = status_cb })
vim.api.nvim_create_autocmd("User", { pattern = "MiniGitUpdated",      group = group, callback = conflict_cb })
-- stylua: ignore end
