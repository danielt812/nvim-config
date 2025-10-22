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

vim.g.inline_blame = true

local show_inline_blame = function()
  local ns_id = vim.api.nvim_create_namespace("inline_blame")
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  if vim.g.inline_blame == false then
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    return
  end

  local use_relative_time = true -- toggle absolute vs relative date
  local prefix = " " -- prefix icon or extra white space
  local show_you_as_author = true -- display author as "You"

  local git_identity = { name = nil, email = nil }

  local get_git_identity = function(root)
    if not git_identity.email then
      git_identity.name = vim.trim(vim.fn.system({
        "git",
        "-C",
        root,
        "config",
        "--get",
        "user.name",
      }))
      git_identity.email = vim.trim(vim.fn.system({
        "git",
        "-C",
        root,
        "config",
        "--get",
        "user.email",
      }))
    end
    return git_identity
  end

  local relative_time = function(ts)
    local current = os.time()
    local delta = current - ts
    if delta < 0 then
      return "in the future"
    end

    local function plural(n, word)
      return string.format("%d %s%s ago", n, word, n == 1 and "" or "s")
    end

    if delta < 5 then
      return "just now"
    elseif delta < 60 then
      return plural(delta, "second")
    elseif delta < 3600 then
      return plural(math.floor(delta / 60), "minute")
    elseif delta < 86400 then
      return plural(math.floor(delta / 3600), "hour")
    end

    local now = os.date("*t", current)
    local then_ = os.date("*t", ts)
    local years = now.year - then_.year
    local months = now.month - then_.month
    local days = now.day - then_.day

    if days < 0 then
      months = months - 1
      local prev_month = (now.month == 1) and 12 or (now.month - 1)
      local prev_year = (now.month == 1) and (now.year - 1) or now.year
      local last_day_prev_month = os.date(
        "*t",
        os.time({
          year = prev_year,
          month = prev_month + 1,
          day = 0,
        })
      ).day
      days = days + last_day_prev_month
    end

    if months < 0 then
      years = years - 1
      months = months + 12
    end

    if years > 0 then
      return plural(years, "year")
    elseif months > 0 then
      return plural(months, "month")
    elseif days > 0 then
      return plural(days, "day")
    else
      return "today"
    end
  end

  local format_time = function(ts)
    return use_relative_time and relative_time(ts) or os.date("%Y-%m-%d", ts)
  end

  local parse_blame_output = function(out)
    local author, author_email, summary, time
    for _, l in ipairs(out) do
      if l:match("^author ") then
        author = l:match("^author%s+(.+)$")
      elseif l:match("^author%-mail ") then
        author_email = l:match("<(.-)>")
      elseif l:match("^summary ") then
        summary = l:match("^summary%s+(.+)$")
      elseif l:match("^author%-time ") then
        local ts = tonumber(l:match("%d+"))
        time = ts and format_time(ts) or ""
      end
    end
    return author, author_email, summary, time
  end

  local get_highlight_group = function()
    local mode = vim.api.nvim_get_mode().mode
    local cursorline_enabled = vim.wo.cursorline
    local is_visual = mode:match("[vV]") ~= nil
    return (is_visual or not cursorline_enabled) and "GitBlameInlineVisual" or "GitBlameInline"
  end

  local bufdata = git.get_buf_data()
  if not bufdata or not bufdata.root then
    return
  end

  local identity = get_git_identity(bufdata.root)
  local file_rel = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local line_num = vim.fn.line(".")

  local cmd = {
    "git",
    "-C",
    bufdata.root,
    "blame",
    "--line-porcelain",
    "-L",
    string.format("%d,%d", line_num, line_num),
    file_rel,
  }

  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or not out or #out == 0 then
    return
  end

  local author, author_email, summary, time = parse_blame_output(out)
  if not (author and summary and time) then
    return
  end

  if show_you_as_author and (author == identity.name or author_email == identity.email) then
    author = "You"
  end

  local virt
  if author == "Not Committed Yet" then
    virt = prefix .. author
  else
    virt = prefix .. string.format("%s • %s • %s", author, time, summary)
  end

  vim.api.nvim_buf_set_extmark(0, ns_id, line_num - 1, 0, {
    virt_text = { { virt, get_highlight_group() } },
    virt_text_pos = "eol",
    priority = 100,
  })
end

vim.api.nvim_create_user_command("BlameInlineToggle", function()
  vim.g.inline_blame = not vim.g.inline_blame
  local msg = vim.g.inline_blame and "Inline blame enabled" or "Inline blame disabled"
  vim.notify(msg, vim.log.levels.INFO)
end, {})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorHold", "CursorHoldI", "ModeChanged" }, {
  group = vim.api.nvim_create_augroup("minigit_blame_inline", { clear = true }),
  pattern = "*",
  callback = show_inline_blame,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("minigit_summary", { clear = true }),
  pattern = "MiniGitUpdated",
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or nil
  end,
})
