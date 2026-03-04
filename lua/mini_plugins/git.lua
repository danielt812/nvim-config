local git = require("mini.git")
local colors = require("mini.colors")

git.setup({
  job = {
    git_executable = "git",
    timeout = 30000,
  },
  command = {
    split = "auto",
  },
})

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

local group = vim.api.nvim_create_augroup("mini_git", { clear = true })

local gen_blame_palette = function(count)
  local dark = vim.o.background == "dark"
  local l = dark and 75 or 45
  local c = dark and 20 or 18
  local offset = vim.uv.hrtime() % 360
  local palette = {}
  for i = 1, count do
    local hue = (offset + (i - 1) * 137.508) % 360
    palette[i] = colors.convert({ l = l, c = c, h = hue }, "hex")
  end
  return palette
end

local gen_hl_groups = function()
  vim.api.nvim_set_hl(0, "MiniGitBlameHash", { link = "Comment" })
  vim.api.nvim_set_hl(0, "MiniGitBlameUncommitted", { link = "Conceal" })
end

gen_hl_groups()

vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", group = group, callback = gen_hl_groups })

local pad_right = function(str, width)
  local pad = width - vim.fn.strwidth(str)
  if pad <= 0 then return str end
  return str .. string.rep(" ", pad)
end

--- Format unix timestamp
---@param timestamp integer Unix timestamp (seconds since epoch)
---@param fmt string os.date format string (e.g. `"%Y-%m-%d"`)
---@param rel? boolean|integer true = always relative, N = relative within N days then fallback to fmt
---@return string
local format_time = function(timestamp, fmt, rel)
  if not rel then return tostring(os.date(fmt, timestamp)) end
  local diff = os.time() - timestamp
  local days = math.floor(diff / 86400)
  if type(rel) == "number" and days >= rel then return tostring(os.date(fmt, timestamp)) end
  local ago = function(n, unit) return n .. (n == 1 and " " .. unit .. " ago" or " " .. unit .. "s ago") end
  if diff < 60 then return ago(diff, "second") end
  if diff < 3600 then return ago(math.floor(diff / 60), "minute") end
  if diff < 86400 then return ago(math.floor(diff / 3600), "hour") end
  if diff < 2592000 then return ago(days, "day") end
  if diff < 31536000 then return ago(math.floor(diff / 2592000), "month") end
  return ago(math.floor(diff / 31536000), "year")
end

local format_blame = function(data, skip_consecutive)
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
      table.insert(formatted, string.format("%s %s %s", entry.sha, pad_right(entry.date, max_date), entry.author))
    end
    prev_sha = entry.sha
  end
  return formatted
end

local parse_porcelain = function(lines)
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
      sha = sha:sub(1, 7),
      author = c.author or "",
      date = c["author-time"] and format_time(c["author-time"], "%Y-%m-%d", 10) or "",
      line = tonumber(final),
    })
    i = i + 1
  end
  return parsed
end

local blame_cb = function(event)
  if event.data.git_subcommand ~= "blame" or not event.data.cmd_input.mods:match("vertical") then return end
  vim.cmd("wincmd H")
  local win_src, buf, win = event.data.win_source, event.buf, event.data.win_stdout

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
  local ns = vim.api.nvim_create_namespace("mini_git_blame")
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
    local ln = i - 1
    if not sha_colors[data.sha] and data.author ~= "Not Committed Yet" then
      color_idx = color_idx + 1
      sha_colors[data.sha] = color_idx
      local color = palette[color_idx]
      vim.api.nvim_set_hl(0, "MiniGitBlameDate" .. color_idx, { fg = color, italic = true })
      vim.api.nvim_set_hl(0, "MiniGitBlameAuthor" .. color_idx, { fg = color })
    end
    if data.author == "Not Committed Yet" then
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameUncommitted" })
    elseif formatted[i] == "┃" then
      -- stylua: ignore
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameDate" .. sha_colors[data.sha] })
    else
      local ci = sha_colors[data.sha]
      local sha_end = #data.sha
      local date_end = sha_end + 1 + #data.date
      -- stylua: ignore start
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = sha_end, hl_group = "MiniGitBlameHash" })
      vim.api.nvim_buf_set_extmark(buf, ns, ln, sha_end + 1, { end_col = date_end, hl_group = "MiniGitBlameDate" .. ci })
      vim.api.nvim_buf_set_extmark(buf, ns, ln, date_end + 1, { end_row = ln, end_col = #formatted[i], hl_group = "MiniGitBlameAuthor" .. ci })
      -- stylua: ignore end
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
  -- stylua: ignore
  for _, line in ipairs(formatted) do max_len = math.max(max_len, #line) end
  vim.api.nvim_win_set_width(win, max_len + math.max(vim.wo[win].numberwidth, #tostring(#formatted) + 1) + 2)

  -- Keymaps
  local get_entry = function() return blame_data[vim.api.nvim_win_get_cursor(win)[1]] end
  local map = function(key, fn, desc) vim.keymap.set("n", key, fn, { buffer = buf, desc = desc }) end

  -- stylua: ignore start
  local with_commit = function(fn) local entry = get_entry() if entry and entry.author ~= "Not Committed Yet" then fn(entry.sha) end end
  local show     = function() with_commit(function(sha) vim.cmd("Git show " .. sha) end) end
  local diff     = function() with_commit(function(sha) vim.cmd("Git diff " .. sha .. "~.." .. sha) end) end
  local checkout = function() with_commit(function(sha) vim.cmd("Git checkout " .. sha) end) end
  local yank     = function() with_commit(function(sha) vim.fn.setreg("+", sha) end) end
  -- stylua: ignore end

  map("s", show, "Show commit")
  map("d", diff, "Diff commit")
  map("c", checkout, "Checkout commit")
  map("y", yank, "Yank sha")

  local close = function()
    if vim.api.nvim_win_is_valid(win_src) then
      -- stylua: ignore
      for opt, val in pairs(saved) do vim.wo[win_src][opt] = val end
    end
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  map("q", close)
  map("<esc>", close)

  -- stylua: ignore
  vim.api.nvim_create_autocmd({ "WinLeave", "BufWipeout" }, { buffer = buf, once = true, callback = close })
end

vim.api.nvim_create_autocmd("User", { pattern = "MiniGitCommandSplit", group = group, callback = blame_cb })
