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
local patch_log = function() vim.cmd("Git log --follow --patch -- %") end

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

-- #############################################################################
-- #                                 Conflict                                  #
-- #############################################################################

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
    -- stylua: ignore start
    { src = "DiffText", header = "ConflictOursHeader",   marker = "ConflictOursMarker",   label = "ConflictOursLabel",   virt = "ConflictOursVirt" },
    { src = "DiffAdd",  header = "ConflictTheirsHeader", marker = "ConflictTheirsMarker", label = "ConflictTheirsLabel", virt = "ConflictTheirsVirt" },
    -- stylua: ignore end
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

local function find_conflicts(buf)
  local conflicts = {}
  local ours, base, theirs

  for ln, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, true)) do
    if vim.startswith(line, "<<<<<<<") then
      ours = { ln }
    elseif vim.startswith(line, "|||||||") then
      base = { ln }
    elseif vim.startswith(line, "=======") then
      if ours then ours[2] = ln end
      if base then base[2] = ln end
      theirs = { ln }
    elseif vim.startswith(line, ">>>>>>>") then
      if theirs then theirs[2] = ln end
      if ours and ours[1] and ours[2] and theirs and theirs[1] and theirs[2] then
        base = base and base[1] and base[2] and base or nil
        table.insert(conflicts, { ours, base, theirs })
      end
      ours, base, theirs = nil, nil, nil
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
    set_marker_hl(ours[1], "ConflictOursHeader", "ConflictOursMarker", "ConflictOursLabel")
    set_marker_hl(theirs[2], "ConflictTheirsHeader", "ConflictTheirsMarker", "ConflictTheirsLabel")
    extmark(ours[1], 0, { end_row = ours[2] - 1, hl_group = "DiffText", hl_eol = true })
    extmark(ours[2] - 1, 0, { line_hl_group = "SpecialKey" })
    extmark(ours[1] - 1, 0, { virt_text = { { "(Ours)", "ConflictOursVirt" } }, virt_text_pos = "eol" })

    extmark(theirs[1], 0, { end_row = theirs[2] - 1, hl_group = "DiffAdd", hl_eol = true })
    extmark(theirs[2] - 1, 0, { virt_text = { { "(Theirs)", "ConflictTheirsVirt" } }, virt_text_pos = "eol" })

    if base then
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

-- #############################################################################
-- #                                   Blame                                   #
-- #############################################################################

local function gen_blame_palette(count)
  vim.api.nvim_set_hl(0, "MiniGitBlameHash", { link = "Comment" })
  vim.api.nvim_set_hl(0, "MiniGitBlameUncommitted", { link = "Conceal" })
  local dark = vim.o.background == "dark"
  local lightness = dark and 75 or 45
  local chroma = dark and 20 or 18
  local uv = vim.uv or vim.loop
  local offset = (uv.hrtime() % 360)
  local palette = {}
  for i = 1, count do
    local hue = (offset + (i - 1) * 137.508) % 360
    palette[i] = colors.convert({ l = lightness, c = chroma, h = hue }, "hex")
  end
  return palette
end

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

  local function ago(n, unit)
    local suffix = n == 1 and "" or "s"
    return string.format("%d %s%s ago", n, unit, suffix)
  end

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

  local function parse_header(line)
    local sha, _, final = line:match("^(%x+) (%d+) (%d+)")
    if not sha then return nil end
    return sha, tonumber(final)
  end

  local function consume_metadata(start_idx, commit)
    local i = start_idx
    while i <= #lines and not lines[i]:match("^\t") do
      local key, val = lines[i]:match("^(%S+)%s?(.*)")
      if key then commit[key] = val end
      i = i + 1
    end
    return i
  end

  local i = 1
  while i <= #lines do
    local sha, final = parse_header(lines[i])
    if not sha then break end

    local commit = commits[sha]
    i = i + 1

    if not commit then
      commit = {}
      commits[sha] = commit
    end

    i = consume_metadata(i, commit)

    table.insert(parsed, {
      sha = sha,
      sha_short = sha:sub(1, 7),
      author = commit.author or "",
      date = commit["author-time"] and format_time(commit["author-time"], "%Y-%m-%d", 10) or "",
      line = final,
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

    -- stylua: ignore
    vim.api.nvim_create_autocmd("ModeChanged", {
      pattern = "i:*",
      group = group,
      callback = function(a) if a.buf == buf then highlight_conflicts(buf) end end,
    })

    vim.api.nvim_create_autocmd("TextChanged", {
      group = group,
      buffer = buf,
      callback = function() highlight_conflicts(buf) end,
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

    local function get_conflict_lines(from, to) return vim.api.nvim_buf_get_lines(0, from - 1, to - 1, true) end

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
  elseif vim.b[buf].minigit_conflicts then
    vim.diagnostic.enable(true, { bufnr = buf })
    vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
    vim.api.nvim_buf_clear_namespace(buf, ns.conflict, 0, -1)
    vim.b[buf].minigit_conflicts = nil
    for _, lhs in ipairs({ "co", "ct", "cb", "cn", "cd", "]x", "[x", "]X", "[X" }) do
      pcall(vim.keymap.del, "n", lhs, { buffer = buf })
    end
  end
end

local function blame_cb(event)
  if event.data.git_subcommand ~= "blame" or not event.data.cmd_input.mods:match("vertical") then return end

  vim.cmd("wincmd H")

  local win_src = event.data.win_source
  local win_blame = event.data.win_stdout
  local buf = event.buf

  local function extmark(line, col, opts) vim.api.nvim_buf_set_extmark(buf, ns.blame, line, col, opts) end

  local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc }) end

  local function set_win_opts(winids, opts)
    local saved = {}
    for _, winid in ipairs(winids) do
      saved[winid] = {}
      for key, val in pairs(opts) do
        saved[winid][key] = vim.wo[winid][key]
        vim.wo[winid][key] = val
      end
    end
    return saved
  end

  local function restore_win_opts(saved, winid)
    if not vim.api.nvim_win_is_valid(winid) or not saved[winid] then return end
    for key, val in pairs(saved[winid]) do
      vim.wo[winid][key] = val
    end
  end

  local function apply_blame_highlights(blame_data, formatted)
    local sha_idx, idx = {}, 0

    for _, entry in ipairs(blame_data) do
      if entry.author ~= "Not Committed Yet" and not sha_idx[entry.sha] then
        idx = idx + 1
        sha_idx[entry.sha] = idx
      end
    end

    local palette = gen_blame_palette(idx)

    for i, entry in ipairs(blame_data) do
      local line = i - 1
      local text = formatted[i]

      if entry.author == "Not Committed Yet" then
        extmark(line, 0, { end_col = #text, hl_group = "MiniGitBlameUncommitted" })
      else
        local ci = sha_idx[entry.sha]
        local date_hl = "MiniGitBlameDate" .. ci
        local author_hl = "MiniGitBlameAuthor" .. ci

        if palette[ci] then
          local color = palette[ci]
          vim.api.nvim_set_hl(0, date_hl, { fg = color, italic = true })
          vim.api.nvim_set_hl(0, author_hl, { fg = color })
          palette[ci] = nil
        end

        if text == "┃" then
          extmark(line, 0, { end_col = #text, hl_group = date_hl })
        else
          local sha_end = #entry.sha_short
          local date_end = sha_end + 1 + #entry.date
          extmark(line, 0, { end_col = sha_end, hl_group = "MiniGitBlameHash" })
          extmark(line, sha_end + 1, { end_col = date_end, hl_group = date_hl })
          extmark(line, date_end + 1, { end_col = #text, hl_group = author_hl })
        end
      end
    end
  end

  -- stylua: ignore
  local win_opts = {
    number = false,
    relativenumber = false,
    winbar = "",
    signcolumn = "no",
    cursorbind = true,
    scrollbind = true,
    wrap = false,
  }

  local saved = set_win_opts({ win_src, win_blame }, win_opts)

  local blame_data = parse_porcelain(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
  local formatted = format_blame(blame_data, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)
  apply_blame_highlights(blame_data, formatted)

  vim.wo[win_blame].number = true
  vim.wo[win_blame].winfixwidth = true
  vim.wo[win_blame].winfixbuf = true
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
  vim.cmd("syncbind")

  local max_width = 0
  for _, line in ipairs(formatted) do
    max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
  end

  vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
  vim.api.nvim_win_set_width(
    win_blame,
    max_width + math.max(vim.wo[win_blame].numberwidth, #tostring(#formatted) + 1) + 2
  )

  local function get_entry() return blame_data[vim.api.nvim_win_get_cursor(win_blame)[1]] end

  local function with_commit(fn)
    local entry = get_entry()
    if entry and entry.author ~= "Not Committed Yet" then fn(entry.sha) end
  end

  local function git_cmd(cmd)
    return function()
      with_commit(function(sha) vim.cmd("Git " .. cmd(sha)) end)
    end
  end

  -- stylua: ignore start
  map("c", git_cmd(function(sha) return "checkout " .. sha end), "Checkout commit")
  map("d", git_cmd(function(sha) return "diff " .. sha .. "^ " .. sha end), "Diff commit")
  map("f", git_cmd(function(sha) return "show --name-status --format=fuller " .. sha end), "Show files in commit")
  map("s", git_cmd(function(sha) return "show " .. sha end), "Show commit")
  map("t", git_cmd(function(sha) return "show --stat --summary --format=fuller " .. sha end), "Show commit stats")
  map("y", function() with_commit(function(sha) vim.fn.setreg("+", sha) vim.notify("Yanked commit " .. sha) end) end, "Yank sha")
  -- stylua: ignore end

  local function close()
    -- stylua: ignore
    for _, win in pairs({ win_src, win_blame }) do restore_win_opts(saved, win) end
    if vim.api.nvim_win_is_valid(win_blame) then vim.api.nvim_win_close(win_blame, true) end
  end

  map("q", close, "Close blame")
  map("<esc>", close, "Close blame")

  vim.api.nvim_create_autocmd({ "WinLeave", "BufWipeout" }, { buffer = buf, once = true, callback = close })
end

-- #############################################################################
-- #                                Git Status                                 #
-- #############################################################################

local function status_cb(event)
  if event.data.git_subcommand ~= "status" then return end
  local buf = event.buf
  vim.bo[buf].filetype = "git"
  vim.cmd("retab")
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local ln = i - 1
    local hl
    if line:match("^%s+modified") then
      hl = "MiniDiffSignAdd"
    elseif line:match("^%s+new file") then
      hl = "MiniDiffSignAdd"
    elseif line:match("^%s+deleted") then
      hl = "MiniDiffSignDelete"
    elseif line:match("^%s+renamed") then
      hl = "DiffChange"
    elseif line:match("^%s+%(use") or line:match("^%s+%(fix") or line:match("^%s+%(all") then
      hl = "Comment"
    elseif line:match("^Changes") or line:match("^Untracked") or line:match("^Unmerged") then
      hl = "Title"
    elseif line:match("^On branch") then
      hl = "Title"
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
