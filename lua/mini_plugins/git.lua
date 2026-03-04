local git = require("mini.git")

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

local blame_split = function() vim.cmd("vertical Git blame --porcelain %") end

vim.keymap.set("n", "<leader>gb", blame_split, { desc = "Blame (split)" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_git", { clear = true })

-- https://www.materialpalette.com
-- stylua: ignore
local blame_palette = { "#8bc34a", "#03a9f4", "#ff5722", "#f44336", "#9c27b0", "#ffc107", "#009688", "#e91e63", "#2196f3", "#3f51b5", "#673ab7", "#4caf50", "#ff9800", "#00bcd4", "#cddc39" }

local apply_blame_hl = function()
  local dark = vim.o.background == "dark"
  vim.api.nvim_set_hl(0, "MiniGitBlameHash", { fg = dark and "#dddddd" or "#333333" })
  vim.api.nvim_set_hl(0, "MiniGitBlameUncommitted", { link = "Comment" })
  for i, color in ipairs(blame_palette) do
    vim.api.nvim_set_hl(0, "MiniGitBlameDate" .. i, { fg = color, italic = true })
    vim.api.nvim_set_hl(0, "MiniGitBlameAuthor" .. i, { fg = color })
  end
end

apply_blame_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  desc = "Apply blame hl groups",
  callback = apply_blame_hl,
})

local parse_porcelain = function(lines)
  local commits, result = {}, {}
  local i = 1
  while i <= #lines do
    local sha, _, final = lines[i]:match("^(%x+) (%d+) (%d+)")
    if not sha then break end
    -- Cache commit info on first encounter
    if not commits[sha] then
      commits[sha] = {}
      i = i + 1
      while i <= #lines and not lines[i]:match("^\t") do
        local key, val = lines[i]:match("^(%S+)%s?(.*)")
        if key then commits[sha][key] = val end
        i = i + 1
      end
    else
      -- Repeated commit, skip to content line
      i = i + 1
      while i <= #lines and not lines[i]:match("^\t") do
        i = i + 1
      end
    end
    local commit = commits[sha]
    table.insert(result, {
      sha = sha:sub(1, 7),
      author = commit.author or "",
      date = commit["author-time"] and os.date("%Y-%m-%d %H:%m", tonumber(commit["author-time"])) or "",
      line = tonumber(final),
    })
    i = i + 1 -- skip the \t content line
  end
  return result
end

local format_blame = function(data)
  local formatted, prev_sha = {}, nil
  for _, entry in ipairs(data) do
    if entry.author == "Not Committed Yet" then
      table.insert(formatted, "Not Committed Yet")
    elseif entry.sha == prev_sha then
      table.insert(formatted, "│")
    else
      table.insert(formatted, string.format("%s %s %s", entry.sha, entry.date, entry.author))
    end
    prev_sha = entry.sha
  end
  return formatted
end

local blame_cb = function(event)
  if event.data.git_subcommand ~= "blame" or not event.data.cmd_input.mods:match("vertical") then return end
  vim.cmd("wincmd H") -- Move window to left
  local win_src = event.data.win_source
  local buf = event.buf
  local win = event.data.win_stdout

  -- stylua: ignore
  local settings = { cursorbind = true, scrollbind = true, number = false, relativenumber = false, winbar = "", signcolumn = "no" }
  local saved = {}
  for k, v in pairs(settings) do
    saved[k] = vim.wo[win_src][k]
    vim.wo[win][k] = v
    vim.wo[win_src][k] = v
  end
  vim.cmd("syncbind")

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local blame_data = parse_porcelain(lines)
  local formatted = format_blame(blame_data)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted)

  local ns = vim.api.nvim_create_namespace("mini_git_blame")
  local sha_colors, color_idx, prev_sha = {}, 0, nil
  for i, entry in ipairs(blame_data) do
    local ln = i - 1
    if not sha_colors[entry.sha] and entry.author ~= "Not Committed Yet" then
      color_idx = (color_idx % #blame_palette) + 1
      sha_colors[entry.sha] = color_idx
    end
    if entry.author == "Not Committed Yet" then
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameUncommitted" })
    elseif entry.sha == prev_sha then
      local ci = sha_colors[entry.sha]
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = #formatted[i], hl_group = "MiniGitBlameDate" .. ci })
    else
      local ci = sha_colors[entry.sha]
      local sha_end = #entry.sha
      local date_start = sha_end + 1
      local date_end = date_start + #entry.date
      local author_start = date_end + 1
      -- stylua: ignore start
      vim.api.nvim_buf_set_extmark(buf, ns, ln, 0, { end_col = sha_end, hl_group = "MiniGitBlameHash" })
      vim.api.nvim_buf_set_extmark(buf, ns, ln, date_start, { end_col = date_end, hl_group = "MiniGitBlameDate" .. ci })
      vim.api.nvim_buf_set_extmark(buf, ns, ln, author_start, { end_row = ln, end_col = #formatted[i], hl_group = "MiniGitBlameAuthor" .. ci })
      -- stylua: ignore end
    end
    prev_sha = entry.sha
  end

  vim.wo[win].number = true
  vim.wo[win].winfixwidth = true
  vim.wo[win].winfixbuf = true
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  local max_len = 0
    -- stylua: ignore
    for _, line in ipairs(formatted) do max_len = math.max(max_len, #line) end
  local numw = math.max(vim.wo[win].numberwidth, #tostring(#formatted) + 1)
  vim.api.nvim_win_set_width(win, max_len + numw + 2)

  local close = function()
    if vim.api.nvim_win_is_valid(win_src) then
      for opt, val in pairs(saved) do
        vim.wo[win_src][opt] = val
      end
    end
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  local get_entry = function() return blame_data[vim.api.nvim_win_get_cursor(win)[1]] end

  vim.keymap.set("n", "s", function()
    local entry = get_entry()
    if entry and entry.author ~= "Not Committed Yet" then vim.cmd("Git show " .. entry.sha) end
  end, { buffer = buf, desc = "Show commit" })

  vim.keymap.set("n", "y", function()
    local entry = get_entry()
    if entry then vim.fn.setreg("+", entry.sha) end
  end, { buffer = buf, desc = "Yank sha" })

  vim.keymap.set("n", "d", function()
    local entry = get_entry()
    if entry and entry.author ~= "Not Committed Yet" then vim.cmd("Git diff " .. entry.sha .. "~.." .. entry.sha) end
  end, { buffer = buf, desc = "Diff commit" })

  local src_file = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win_src))

  vim.keymap.set("n", "l", function()
    vim.cmd("Git log --follow " .. vim.fn.fnameescape(src_file))
  end, { buffer = buf, desc = "File log" })

  vim.keymap.set("n", "c", function()
    local entry = get_entry()
    if entry and entry.author ~= "Not Committed Yet" then vim.cmd("Git checkout " .. entry.sha) end
  end, { buffer = buf, desc = "Checkout commit" })

  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.keymap.set("n", "<esc>", close, { buffer = buf })

  vim.api.nvim_create_autocmd({ "WinLeave", "BufWipeout" }, {
    group = group,
    buffer = buf,
    once = true,
    callback = close,
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitCommandSplit",
  group = group,
  desc = "Blame",
  callback = blame_cb,
})
