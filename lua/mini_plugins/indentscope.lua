local indentscope = require("mini.indentscope")

indentscope.setup({
  -- Draw options
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    animation = indentscope.gen_animation.quadratic({ easing = "out", duration = 100, unit = "total" }),

    -- Whether to auto draw scope: return `true` to draw, `false` otherwise.
    -- Default draws only fully computed scope (see `options.n_lines`).
    predicate = function(scope)
      local ft_ignore = { "help", "markdown" }
      if not vim.api.nvim_buf_is_valid(scope.buf_id) then return false end
      if vim.tbl_contains(ft_ignore, vim.bo[scope.buf_id].filetype) then return false end
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

local indent_cache = {}

local get_indent = function(buf, lnum)
  return vim.api.nvim_buf_call(buf, function()
    if vim.fn.getline(lnum):match("^%s*$") == nil then return vim.fn.indent(lnum) end
    local p, n = vim.fn.prevnonblank(lnum), vim.fn.nextnonblank(lnum)
    return math.max(p > 0 and vim.fn.indent(p) or 0, n > 0 and vim.fn.indent(n) or 0)
  end)
end

local render = function(buf, win)
  local ns = vim.api.nvim_create_namespace("indent_guides")
  if vim.g.miniindentscope_disable or vim.b[buf].miniindentscope_disable then
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    return
  end
  if vim.bo[buf].buftype ~= "" then return end
  local win_config = vim.api.nvim_win_get_config(win)
  if win_config and win_config.relative ~= "" then return end

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
        if is_blank or ch == " " or ch == "\t" then -- NOTE: remove \t check if you want ext mark over tabs (:h retab)
          vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
            virt_text = { { "│", "NonText" } },
            virt_text_pos = "overlay",
            virt_text_win_col = win_col,
            virt_text_repeat_linebreak = true, -- INFO: requires v0.10.0 or greater
            hl_mode = "combine",
            priority = 1, -- NOTE: this needs to be lower than mini.indentscope
          })
        end
      end
    end
  end
end

local draw = function(opts)
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

local draw_lazy = function() draw({ lazy = true }) end
local draw_now = function() draw({ lazy = false }) end

local group = vim.api.nvim_create_augroup("indent_guides", { clear = true })

local au = function(event, pattern, cb)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = cb })
end

au({ "CursorMoved", "CursorMovedI", "ModeChanged" }, "*", draw_lazy)
au({ "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }, "*", draw_now)
local opt_patterns = { "shiftwidth", "tabstop", "expandtab" }
au({ "OptionSet" }, opt_patterns, draw_now)

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local toggle_indentscope = function()
  vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "<leader>\\i", toggle_indentscope, { desc = "Indentscope" })
