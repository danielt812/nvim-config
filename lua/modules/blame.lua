-- #############################################################################
-- #                               Blame Module                                #
-- #############################################################################

-- Module definition -----------------------------------------------------------
local ModBlame = {}
local H = {}

-- Generators ------------------------------------------------------------------
ModBlame.gen_format = {}

ModBlame.gen_hook = {}

-- Examples:
-- on_select = ModBlame.gen_hook.commit(function(data)
--   vim.fn.setreg("+", data.hash) -- yank hash to system clipboard
-- end)
--
-- on_select = ModBlame.gen_hook.commit(function(data)
--   vim.cmd("Git show " .. data.hash) -- open in mini.git
-- end)
--
-- on_select = ModBlame.gen_hook.commit(function(data)
--   vim.notify(data.summary) -- show commit message
-- end)
ModBlame.gen_hook.commit = function(cb)
  return function(data) cb(data) end
end

ModBlame.gen_format.hash = function(opts)
  opts = opts or {}
  local length = opts.length or 7
  return function(args) return args.commit and args.commit:sub(1, length) or "" end
end

ModBlame.gen_format.date = function(opts)
  opts = opts or {}
  local fmt = opts.format or "%m-%d-%Y %H:%M"
  return function(args)
    if not args.time then return "" end
    local rel = opts.relative
    if rel == true or (type(rel) == "number" and (os.time() - args.time) / 86400 < rel) then
      return H.format_relative(args.time)
    end
    return os.date(fmt, args.time)
  end
end

ModBlame.gen_format.author = function(opts)
  opts = opts or {}
  return function(args)
    local name = args.author
    if not name or name == "" then return "" end
    local words = {}
    for w in name:gmatch("%S+") do
      table.insert(words, w)
    end
    if #words == 0 then return name end
    local initialize = opts.initialize
    if initialize == "last" then
      words[#words] = words[#words]:sub(1, 1) .. "."
    elseif initialize == "first" then
      words[1] = words[1]:sub(1, 1) .. "."
    elseif initialize == "all" then
      local initials = {}
      for _, w in ipairs(words) do
        table.insert(initials, w:sub(1, 1) .. ".")
      end
      return table.concat(initials, "")
    end
    return table.concat(words, " ")
  end
end

ModBlame.setup = function(config)
  -- Export module
  _G.ModBlame = ModBlame

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

-- Defaults
ModBlame.config = {
  mappings = {
    file = "<leader>gB",
    line = "<leader>gb",
  },

  file = {
    -- auto close blame window on unfocus
    auto_close = true,
    -- move numbers to blame window
    numbers = true,
    -- show commits as consecutive
    merge_consecutive = true,

    format = {
      ModBlame.gen_format.hash({ length = 7 }),
      ModBlame.gen_format.date({ relative = 10 }),
      ModBlame.gen_format.author({ initialize = "last" }),
    },

    commit_colors = {},

    select = ModBlame.gen_hook.commit(function(data) vim.cmd("Git show " .. data.hash) end),
  },
}

-- Module functionality --------------------------------------------------------
ModBlame.file = function()
  local buf = vim.api.nvim_get_current_buf()

  -- If we're inside a blame window, close it via its source buf entry
  for src_bufnr, cache in pairs(H.cache.window) do
    if cache.win == vim.api.nvim_get_current_win() then
      vim.api.nvim_win_close(cache.win, true)
      H.cache.window[src_bufnr] = nil
      return
    end
  end

  local existing = H.cache.window[buf]
  if existing and vim.api.nvim_win_is_valid(existing.win) then
    vim.api.nvim_win_close(existing.win, true)
    H.cache.window[buf] = nil
    return
  end

  local blame_win = H.create_window()
  H.cache.window[buf] = blame_win

  local function close() H.close_window(buf) end
  vim.keymap.set("n", "q", close, { buffer = blame_win.buf, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = blame_win.buf, silent = true })

  local file = vim.api.nvim_buf_get_name(buf)
  H.get_blame(file, function(blame)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(blame_win.buf) then return end
      local config = H.get_config()
      local line_count = vim.api.nvim_buf_line_count(buf)
      local lines = {}
      local merged = {}
      local line_hash = {}
      local raw_parts = {} -- [i] -> array of column strings for committed lines

      -- Pass 1: collect raw column values and track hashes
      local prev_hash = nil
      for i = 1, line_count do
        local entry = blame and blame[i]
        local cur_hash = H.is_uncommitted(entry) and "__uncommitted__" or entry.hash
        line_hash[i] = cur_hash

        if config.file.merge_consecutive and cur_hash == prev_hash then
          merged[i] = true
        elseif cur_hash ~= "__uncommitted__" then
          local time = tonumber(entry["author-time"])
          local date = H.format_date(entry)
          local author = entry.author or ""
          raw_parts[i] =
            H.collect_parts(config.file.format, { commit = entry.hash, date = date, author = author, time = time })
        end

        prev_hash = cur_hash
      end

      -- Compute max width per column across all committed lines
      local col_widths = {}
      for i = 1, line_count do
        if raw_parts[i] then
          for j, s in ipairs(raw_parts[i]) do
            col_widths[j] = math.max(col_widths[j] or 0, vim.fn.strwidth(s))
          end
        end
      end

      -- Pass 2: build padded lines
      for i = 1, line_count do
        if merged[i] then
          lines[i] = ""
        elseif line_hash[i] == "__uncommitted__" then
          lines[i] = "Not Committed Yet"
        else
          local parts = raw_parts[i]
          local pieces = {}
          for j, s in ipairs(parts) do
            pieces[j] = j < #parts and H.pad_right(s, col_widths[j]) or s
          end
          lines[i] = table.concat(pieces, " ")
        end
      end

      H.create_highlights_for_blame(blame or {})
      vim.api.nvim_buf_set_lines(blame_win.buf, 0, -1, false, lines)
      vim.bo[blame_win.buf].modifiable = false

      local max_width = 0
      for _, line in ipairs(lines) do
        max_width = math.max(max_width, vim.fn.strwidth(line))
      end
      local textoff = vim.fn.getwininfo(blame_win.win)[1].textoff
      vim.api.nvim_win_set_width(blame_win.win, max_width + 2 + textoff)

      for i = 1, line_count do
        local cur_hash = line_hash[i]
        local commit_hl = cur_hash ~= "__uncommitted__" and cur_hash:sub(1, 7) or nil

        if merged[i] then
          vim.api.nvim_buf_set_extmark(blame_win.buf, H.ns, i - 1, 0, {
            virt_text = { { "│", commit_hl } },
            virt_text_pos = "overlay",
          })
        elseif cur_hash == "__uncommitted__" then
          vim.api.nvim_buf_set_extmark(blame_win.buf, H.ns, i - 1, 0, {
            end_col = #lines[i],
            hl_group = "ModBlameUncommitted",
          })
        else
          local space = lines[i]:find(" ") -- 1-indexed; nil if no space
          local hash_end = space and (space - 1) or #lines[i]
          vim.api.nvim_buf_set_extmark(blame_win.buf, H.ns, i - 1, 0, {
            end_col = hash_end,
            hl_group = "ModBlameHash",
          })
          if space then
            vim.api.nvim_buf_set_extmark(blame_win.buf, H.ns, i - 1, space, {
              end_col = #lines[i],
              hl_group = commit_hl,
            })
          end
        end
      end

      vim.keymap.set("n", "<CR>", function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local cur_hash = line_hash[row]
        if not cur_hash or cur_hash == "__uncommitted__" then return end
        local entry = blame and blame[row]
        if entry then config.file.select(entry) end
      end, { buffer = blame_win.buf, silent = true, nowait = true })
    end)
  end)
end

ModBlame.line = function() end

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModBlame.config)

H.cache = {
  window = {},
}

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")
  H.check_type("mappings.file", config.mappings.file, "string")
  H.check_type("mappings.line", config.mappings.line, "string")

  H.check_type("file", config.file, "table")
  H.check_type("file.auto_close", config.file.auto_close, "boolean")
  H.check_type("file.numbers", config.file.numbers, "boolean")
  H.check_type("file.merge_consecutive", config.file.merge_consecutive, "boolean")
  H.check_type("file.format", config.file.format, "table")
  H.check_type("file.commit_colors", config.file.commit_colors, "table")
  H.check_type("file.select", config.file.select, "callable")

  return config
end

H.ns = vim.api.nvim_create_namespace("ModBlame")

H.apply_config = function(config)
  ModBlame.config = config

  H.create_autocommands()

  H.create_default_hl()

  H.map("n", config.mappings.file, ModBlame.file, { desc = "Blame (file)" })
  H.map("n", config.mappings.line, ModBlame.line, { desc = "Blame (line)" })
end

H.create_autocommands = function()
  local group = vim.api.nvim_create_augroup("ModBlame", { clear = true })

  local function au(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end

  au("ColorScheme", "*", H.create_default_hl, "Ensure colors")
  au("WinLeave", "*", H.on_win_leave, "Auto-close blame window on leave")
end

H.create_default_hl = function()
  vim.api.nvim_set_hl(0, "ModBlameHash", { link = "Conceal", default = true })
  vim.api.nvim_set_hl(0, "ModBlameUncommitted", { link = "Conceal", default = true })
  vim.api.nvim_set_hl(0, "ModBlameMerged", { link = "White", default = true })
end

H.hsl_to_hex = function(h, s, l)
  local c = (1 - math.abs(2 * l - 1)) * s
  local x = c * (1 - math.abs((h / 60) % 2 - 1))
  local m = l - c / 2
  local r, g, b
  if h < 60 then
    r, g, b = c, x, 0
  elseif h < 120 then
    r, g, b = x, c, 0
  elseif h < 180 then
    r, g, b = 0, c, x
  elseif h < 240 then
    r, g, b = 0, x, c
  elseif h < 300 then
    r, g, b = x, 0, c
  else
    r, g, b = c, 0, x
  end
  return string.format("#%02X%02X%02X", math.floor((r + m) * 255), math.floor((g + m) * 255), math.floor((b + m) * 255))
end

-- Golden angle (~137.5°) guarantees maximum hue distance between consecutive colors.
-- Lightness follows a triangle wave: slowly drifts between safe limits, bouncing
-- at the boundaries. At each bounce the hue has already shifted far enough to
-- look like a "new starting point" without any extra bookkeeping.
H.sequential_commit_color = function(index)
  local golden_angle = 137.508
  local hue = (index * golden_angle) % 360

  local is_dark = vim.o.background == "dark"
  local s = is_dark and 0.55 or 0.72
  local l_min = is_dark and 0.48 or 0.28
  local l_max = is_dark and 0.75 or 0.55

  -- Triangle wave: ramps from l_min → l_max over `period` steps, then back
  local period = 12
  local phase = (index % (period * 2)) / period -- 0 .. 2
  local l = phase <= 1 and (l_min + phase * (l_max - l_min)) or (l_max - (phase - 1) * (l_max - l_min))

  return H.hsl_to_hex(hue, s, l)
end

H.pick_spread_indices = function(num_colors, num_commits)
  if num_commits == 1 then return { math.ceil(num_colors / 2) } end
  local indices = {}
  for i = 1, num_commits do
    local pos = (num_colors + 1) * i / (num_commits + 1)
    table.insert(indices, math.floor(pos + 0.5))
  end
  return indices
end

H.create_highlights_for_blame = function(blame)
  local config = H.get_config()

  local hash_time = {}
  for _, entry in pairs(blame) do
    if not H.is_uncommitted(entry) and not hash_time[entry.hash] then
      hash_time[entry.hash] = tonumber(entry["author-time"]) or 0
    end
  end

  local sorted = vim.tbl_keys(hash_time)
  table.sort(sorted, function(a, b) return hash_time[a] < hash_time[b] end)

  local palette_indices = nil
  if config.file.commit_colors and #config.file.commit_colors > 0 then
    palette_indices = H.pick_spread_indices(#config.file.commit_colors, #sorted)
  end

  for color_index, hash in ipairs(sorted) do
    local short = hash:sub(1, 7)
    if vim.fn.hlID(short) == 0 then
      local fg
      if palette_indices then
        fg = config.file.commit_colors[palette_indices[color_index]]
      else
        fg = H.sequential_commit_color(color_index - 1)
      end
      vim.api.nvim_set_hl(0, short, { fg = fg })
    end
  end
end

H.is_uncommitted = function(entry)
  if not entry then return true end
  if entry.hash:match("^0+$") then return true end
  return false
end

H.format_relative = function(timestamp)
  local diff = os.time() - timestamp
  if diff < 60 then return "just now" end
  if diff < 3600 then return table.concat({ math.floor(diff / 60), "minutes ago" }, " ") end
  if diff < 86400 then return table.concat({ math.floor(diff / 3600), "hours ago" }, " ") end
  if diff < 2592000 then return table.concat({ math.floor(diff / 86400), "days ago" }, " ") end
  if diff < 31536000 then return table.concat({ math.floor(diff / 2592000), "months ago" }, " ") end
  return table.concat({ math.floor(diff / 31536000), "years ago" }, " ")
end

H.collect_parts = function(parts, args)
  local pieces = {}
  for _, part in ipairs(parts) do
    local s = part(args)
    if s and s ~= "" then table.insert(pieces, s) end
  end
  return pieces
end

H.pad_right = function(str, width)
  local pad = width - vim.fn.strwidth(str)
  if pad <= 0 then return str end
  return str .. string.rep(" ", pad)
end

H.format_date = function(entry)
  local timestamp = tonumber(entry["author-time"])
  if not timestamp then return "" end
  return os.date("%m-%d-%Y %H:%M", timestamp)
end

H.on_win_leave = function()
  if not H.get_config().file.auto_close then return end
  local blame_win = vim.api.nvim_get_current_win()
  for src_bufnr, state in pairs(H.cache.window) do
    if state.win == blame_win then H.close_window(src_bufnr) end
  end
end

H.get_config = function(config)
  return vim.tbl_deep_extend("force", ModBlame.config, vim.b.blame_config or {}, config or {})
end

-- Blame data ------------------------------------------------------------------
H.get_blame = function(file, callback)
  vim.system({ "git", "blame", "--porcelain", file }, { text = true }, function(result)
    if result.code ~= 0 then
      callback(nil)
      return
    end
    callback(H.parse_porcelain(result.stdout))
  end)
end

H.parse_porcelain = function(output)
  local commits = {} -- hash -> commit info (metadata stored once)
  local blame = {} -- final_lineno -> commit info

  local cur_hash = nil
  local cur_final = nil

  for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
    -- Header line: 40 hex chars then a space
    if #line >= 41 and line:sub(41, 41) == " " and line:sub(1, 40):match("^%x+$") then
      local hash = line:sub(1, 40)
      local final = line:match("^%x+%s+%d+%s+(%d+)")
      cur_hash = hash
      cur_final = tonumber(final)
      if not commits[cur_hash] then commits[cur_hash] = { hash = cur_hash } end
    elseif line:sub(1, 1) == "\t" then
      -- Content line: finalize the entry for this line number
      if cur_hash and cur_final then blame[cur_final] = commits[cur_hash] end
      cur_hash = nil
      cur_final = nil
    elseif cur_hash then
      -- Metadata key/value (only store on first occurrence per commit)
      local key, val = line:match("^(%S+)%s+(.*)")
      if key and val and commits[cur_hash][key] == nil then commits[cur_hash][key] = val end
    end
  end

  return blame
end

-- Window ----------------------------------------------------------------------

H.close_window = function(src_bufnr)
  local w = H.cache.window[src_bufnr]
  if not w then return end
  H.cache.window[src_bufnr] = nil
  if vim.api.nvim_win_is_valid(w.source_win) then
    vim.wo[w.source_win].wrap = w.source_wrap
    vim.wo[w.source_win].winbar = w.source_winbar
    vim.wo[w.source_win].number = w.source_number
    vim.wo[w.source_win].relativenumber = w.source_relativenumber
    vim.wo[w.source_win].signcolumn = w.source_signcolumn
    vim.wo[w.source_win].scrollbind = false
    vim.wo[w.source_win].cursorbind = false
  end
  if vim.api.nvim_win_is_valid(w.win) then vim.api.nvim_win_close(w.win, true) end
end

-- Creates a scratch buffer and opens it in a left vsplit.
-- Returns { buf, win, source_win }.
H.create_window = function()
  local source_win = vim.api.nvim_get_current_win()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "git"

  vim.cmd("leftabove vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  local numbers = H.get_config().file.numbers
  vim.wo[win].number = numbers
  vim.wo[win].relativenumber = false
  vim.wo[win].winfixwidth = true
  vim.wo[win].winfixbuf = true
  vim.wo[win].scrollbind = true
  vim.wo[win].cursorbind = true

  local source_wrap = vim.wo[source_win].wrap
  local source_winbar = vim.wo[source_win].winbar
  local source_number = vim.wo[source_win].number
  local source_relativenumber = vim.wo[source_win].relativenumber
  local source_signcolumn = vim.wo[source_win].signcolumn
  vim.wo[source_win].wrap = false
  vim.wo[source_win].winbar = ""
  if numbers then
    vim.wo[source_win].number = false
    vim.wo[source_win].relativenumber = false
    vim.wo[source_win].signcolumn = "no"
  end
  vim.wo[source_win].scrollbind = true
  vim.wo[source_win].cursorbind = true
  vim.cmd("syncbind")

  return {
    buf = buf,
    win = win,
    source_win = source_win,
    source_wrap = source_wrap,
    source_winbar = source_winbar,
    source_number = source_number,
    source_relativenumber = source_relativenumber,
    source_signcolumn = source_signcolumn,
  }
end

-- Autocommands ----------------------------------------------------------------
-- Autocmd callbacks goes here

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(module.blame) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return ModBlame
