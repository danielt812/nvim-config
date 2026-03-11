local indentscope = require("mini.indentscope")

local ft_ignore = { "git", "help", "man", "markdown", "terminal" }

local function should_ignore(ft) return ft:match("^mini") or vim.tbl_contains(ft_ignore, ft) end

indentscope.setup({
  -- Draw options
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    animation = indentscope.gen_animation.quadratic({ easing = "out", duration = 100, unit = "total" }),

    -- Whether to auto draw scope: return `true` to draw, `false` otherwise.
    -- Default draws only fully computed scope (see `options.n_lines`).
    predicate = function(scope)
      if not vim.api.nvim_buf_is_valid(scope.buf_id) then return false end
      if should_ignore(vim.bo[scope.buf_id].filetype) then return false end
      return not scope.body.is_incomplete
    end,

    -- Symbol priority. Increase to display on top of more symbols.
    priority = 2,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = "ii",
    object_scope_with_border = "ai",

    -- Motions (jump to respective border line; if not present - body line)
    goto_top = "[i",
    goto_bottom = "]i",
  },

  -- Options which control scope computation
  options = {
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
    border = "both",

    -- Whether to use cursor column when computing reference indent.
    -- Useful to see incremental scopes with horizontal cursor movements.
    indent_at_cursor = true,

    -- Maximum number of lines above or below within which scope is computed
    n_lines = 10000,

    -- Whether to first check input line to be a border of adjacent scope.
    -- Use it if you want to place cursor on function header to get scope of
    -- its body.
    try_as_border = true,
  },

  -- Which character to use for drawing scope indicator
  symbol = "│",
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function toggle_indentscope()
  vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "\\2", toggle_indentscope, { desc = "Toggle 'mini.indentscope'" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local ns = vim.api.nvim_create_namespace("indent_guides")
local indent_cache = {}

local function get_indent(buf, lnum)
  return vim.api.nvim_buf_call(buf, function()
    if vim.fn.getline(lnum):match("^%s*$") == nil then return vim.fn.indent(lnum) end
    local p, n = vim.fn.prevnonblank(lnum), vim.fn.nextnonblank(lnum)
    return math.max(p > 0 and vim.fn.indent(p) or 0, n > 0 and vim.fn.indent(n) or 0)
  end)
end

local function render(buf, win)
  if vim.b[buf].miniindentscope_disable or should_ignore(vim.bo[buf].filetype) then return end
  local win_config = vim.api.nvim_win_get_config(win)
  if win_config and win_config.relative ~= "" then return end -- Don't render on some floats (hover, cmp, etc...)

  local sw = vim.bo[buf].shiftwidth
  local step = sw > 0 and sw or vim.bo[buf].tabstop
  if step <= 0 then return end

  -- NOTE: rendering just the visible range is more performant, but lines outside the viewport won't have guides
  -- local top, bot = vim.fn.line("w0", win), vim.fn.line("w$", win)
  -- vim.api.nvim_buf_clear_namespace(buf, ns, top - 1, bot)
  local top, bot = 1, vim.api.nvim_buf_line_count(buf)
  local leftcol = vim.api.nvim_win_call(win, function() return vim.fn.winsaveview().leftcol end)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

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

local function draw_indent_guides(opts)
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

local group = vim.api.nvim_create_augroup("mini_indentscope", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "CursorMovedI", "ModeChanged" }, {
  pattern = "*",
  group = group,
  callback = function() draw_indent_guides({ lazy = true }) end,
  desc = "Draw indent guides lazily",
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }, {
  pattern = "*",
  group = group,
  callback = function() draw_indent_guides({ lazy = false }) end,
  desc = "Draw indent guides",
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = { "shiftwidth", "tabstop" },
  group = group,
  callback = function() draw_indent_guides({ lazy = false }) end,
  desc = "Redraw when options affect steps",
})
