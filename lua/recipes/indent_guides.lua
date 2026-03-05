local ns = vim.api.nvim_create_namespace("indent_guides")
local indent_cache = {}

local get_indent = function(buf, lnum)
  return vim.api.nvim_buf_call(buf, function()
    if vim.fn.getline(lnum):match("^%s*$") == nil then return vim.fn.indent(lnum) end
    local p, n = vim.fn.prevnonblank(lnum), vim.fn.nextnonblank(lnum)
    return math.max(p > 0 and vim.fn.indent(p) or 0, n > 0 and vim.fn.indent(n) or 0)
  end)
end

local render = function(buf, win)
  if vim.bo[buf].buftype ~= "" then return end
  local win_config = vim.api.nvim_win_get_config(win)
  if win_config and win_config.relative ~= "" then return end -- Don't render on some floats (hover, cmp, etc...)

  local sw = vim.bo[buf].shiftwidth
  local step = sw > 0 and sw or vim.bo[buf].tabstop
  if step <= 0 then return end

  local top, bot = vim.fn.line("w0", win), vim.fn.line("w$", win)
  local leftcol = vim.api.nvim_win_call(win, function() return vim.fn.winsaveview().leftcol end)
  vim.api.nvim_buf_clear_namespace(buf, ns, top - 1, bot)

  for lnum = top, bot do
    local indent = get_indent(buf, lnum)
    local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
    local is_blank = line:match("^%s*$") ~= nil

    for col = 0, indent - 1, step do
      local win_col = col - leftcol
      if win_col >= 0 then
        local ch = line:sub(col + 1, col + 1)
        if is_blank or ch == " " or ch == "\t" then -- Remove \t check if you want ext mark over tabs (:h retab)
          vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
            virt_text = { { "│", "NonText" } },
            virt_text_pos = "overlay",
            virt_text_win_col = win_col,
            virt_text_repeat_linebreak = true, -- Requires v0.10.0 or greater
            hl_mode = "combine",
            priority = 1, -- This should be lower than mini.indentscope ext mark priority
          })
        end
      end
    end
  end
end

local draw = function(opts)
  opts = opts or {}
  -- Clear highlight when miniindentscope does
  if vim.g.miniindentscope_disable or vim.b.miniindentscope_disable then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
    return
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if opts.lazy then
      local key = buf .. ":" .. vim.fn.line("w0", win) .. ":" .. vim.fn.line("w$", win)
      if indent_cache[win] == key then goto continue end
      indent_cache[win] = key
    end
    render(buf, win)
    ::continue::
  end
end

local gr = vim.api.nvim_create_augroup("indent_guidelines", { clear = true })
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = gr, pattern = pattern, callback = callback, desc = desc })
end

local lazy_events = { "CursorMoved", "CursorMovedI", "ModeChanged" }
au(lazy_events, "*", function() draw({ lazy = true }) end, "Draw indent guides lazily")
local now_events = { "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }
au(now_events, "*", function() draw() end, "Draw indent guides")
local opt_patterns = { "shiftwidth", "tabstop", "expandtab" }
au({ "OptionSet" }, opt_patterns, function() draw() end, "Redraw when options affect steps")
