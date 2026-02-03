local function is_uncommitted(item)
  if not item then return false end
  if item.hash:match("^0+$") then return true end
  if item.author:lower():find("not committed yet", 1, true) then return true end
  return false
end

local function format_time_slash(time_str)
  local y, m, d, hh, mm = time_str:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)%s+(%d%d):(%d%d)")
  if not y then return time_str end
  return string.format("%s/%s/%s - %s:%s", m, d, y, hh, mm)
end

local function parse_blame_line(line)
  -- hash + "(meta)" part
  local hash, meta = line:match("^(%S+)%s+%((.-)%)")
  if not hash or not meta then return nil end

  local author, date, time, tz = meta:match("^(.-)%s+(%d%d%d%d%-%d%d%-%d%d)%s+(%d%d:%d%d:%d%d)%s+([%+%-]%d+)%s+%d+$")
  if not author then return nil end

  author = vim.trim(author)
  local time_str = string.format("%s %s %s", date, time, tz)

  return {
    hash = hash,
    author = author,
    time = time_str,
  }
end

local function pad_right(str, width)
  local w = vim.fn.strwidth(str)
  if w >= width then return str end
  return str .. string.rep(" ", width - w)
end

local function column_widths(items)
  local w_hash, w_author = 0, 0
  for _, it in ipairs(items) do
    if not is_uncommitted(it) then
      w_hash = math.max(w_hash, vim.fn.strwidth(it.hash))
      w_author = math.max(w_author, vim.fn.strwidth(it.author))
    end
  end
  return w_hash, w_author
end

local BLAME_NS = vim.api.nvim_create_namespace("git_blame_parts")

local palette = {
  "Identifier",
  "String",
  "Type",
  "Function",
  "Keyword",
  "Constant",
  "Number",
  "Statement",
  "PreProc",
}

local function hl_for_hash(hash, map)
  local hl = map[hash]
  if hl then return hl end
  local next_index = (vim.tbl_count(map) % #palette) + 1
  hl = palette[next_index]
  map[hash] = hl
  return hl
end

local function apply_blame_extmarks(bufnr, blame_parts, w_hash, w_author)
  vim.api.nvim_buf_clear_namespace(bufnr, BLAME_NS, 0, -1)

  -- output line format: "<hash padded>␠␠<author padded>␠␠<time>"
  local author_col = w_hash + 2
  local time_col = author_col + w_author + 2

  local hash_to_hl = {}

  for i, item in ipairs(blame_parts) do
    local row0 = i - 1

    if not is_uncommitted(item) then
      local time = format_time_slash(item.time)
      local end_col = time_col + vim.fn.strwidth(time)

      -- 1) hash always comment
      vim.api.nvim_buf_set_extmark(bufnr, BLAME_NS, row0, 0, {
        end_col = w_hash, -- highlight just the hash column area
        hl_group = "Comment",
        hl_mode = "combine",
      })

      -- 2) author + time colored per commit
      local hl = hl_for_hash(item.hash, hash_to_hl)
      vim.api.nvim_buf_set_extmark(bufnr, BLAME_NS, row0, author_col, {
        end_col = end_col,
        hl_group = hl,
        hl_mode = "combine",
      })
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitCommandSplit",
  callback = function(e)
    vim.api.nvim_set_hl(0, "GitBlameHashRoot", { link = "Tag" })
    vim.api.nvim_set_hl(0, "GitBlameHash", { link = "Identifier" })
    vim.api.nvim_set_hl(0, "GitBlameAuthor", { link = "String" })
    vim.api.nvim_set_hl(0, "GitBlameDate", { link = "Comment" })
    -- stylua: ignore
    if e.data.git_subcommand ~= "blame" then return end
    local win_src = e.data.win_source
    local buf = e.buf
    local win = e.data.win_stdout

    -- Auto-close blame window when you leave it
    do
      local aug = vim.api.nvim_create_augroup("mini_git_blame_autoclose", { clear = false })

      -- Clear any previous autoclose for this blame buffer (so you don't stack them)
      vim.api.nvim_clear_autocmds({ group = aug, buffer = buf })

      vim.api.nvim_create_autocmd("WinLeave", {
        group = aug,
        buffer = buf,
        callback = function()
          if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        end,
        desc = "Auto-close mini.git blame window on leave",
      })
    end

    vim.cmd("wincmd H")

    local blame_parts = {}

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    for _, line in ipairs(lines) do
      local item = parse_blame_line(line)
      if item then table.insert(blame_parts, item) end
    end

    local w_hash, w_author = column_widths(blame_parts)

    local output = {}

    for _, item in ipairs(blame_parts) do
      if is_uncommitted(item) then
        table.insert(output, "") -- blank entire line
      else
        local time = format_time_slash(item.time)
        local hash = pad_right(item.hash, w_hash)
        local author = pad_right(item.author, w_author)
        table.insert(output, string.format("%s  %s  %s", hash, author, time))
      end
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
    apply_blame_extmarks(buf, blame_parts, w_hash, w_author)
    -- Opts
    vim.bo[buf].modifiable = false
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false

    -- View
    vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })
    vim.wo[win].scrollbind, vim.wo[win_src].scrollbind = true, true
    vim.wo[win].cursorbind, vim.wo[win_src].cursorbind = true, true
    -- Vert width
    if e.data.cmd_input.mods:match("vertical") then
      local width = vim.iter(output):fold(0, function(acc, ln)
        if ln == "" then return acc end
        return math.max(acc, vim.fn.strwidth(ln))
      end)

      width = width + vim.fn.getwininfo(win)[1].textoff
      width = math.max(1, width + 2)

      vim.api.nvim_win_set_width(win, width)
    end
  end,
})
