local indentscope = require("mini.indentscope")

local ft_ignore = { "checkhealth", "git", "help", "man", "markdown", "terminal", "mason" }

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
      if vim.fn.foldclosed(scope.reference.line) ~= -1 then return false end
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
-- #                               Indent Guides                               #
-- #############################################################################

do
  local ns = vim.api.nvim_create_namespace("indent_guides")
  local state = {}

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
    if win_config and win_config.relative ~= "" and win ~= vim.api.nvim_get_current_win() then return end

    local sw = vim.bo[buf].shiftwidth
    local step = sw > 0 and sw or vim.bo[buf].tabstop
    if step <= 0 then return end

    local view = vim.api.nvim_win_call(win, function() return vim.fn.winsaveview() end)
    local top = view.topline
    local bot = math.min(top + vim.api.nvim_win_get_height(win) - 1, vim.api.nvim_buf_line_count(buf))
    local leftcol = view.leftcol
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    for lnum = top, bot do
      if vim.fn.foldclosed(lnum) ~= -1 then goto continue end

      local indent = get_indent(buf, lnum)
      local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
      local is_blank = line:match("^%s*$") ~= nil

      for col = 0, indent - 1, step do
        local win_col = col - leftcol
        if win_col >= 0 and (is_blank or col < indent) then
          vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
            virt_text = { { "│", "NonText" } },
            virt_text_pos = "overlay",
            virt_text_win_col = win_col,
            virt_text_repeat_linebreak = true,
            hl_mode = "combine",
            priority = 1, -- This should be lower than mini.indentscope ext mark priority
          })
        end
      end
      ::continue::
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
        if state[win] == key then goto continue end
        state[win] = key
      end
      render(buf, win)
      ::continue::
    end
  end

  local group = vim.api.nvim_create_augroup("mini_indentscope", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "CursorMovedI", "ModeChanged" }, {
    group = group,
    callback = function() draw_indent_guides({ lazy = true }) end,
    desc = "Draw indent guides lazily",
  })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "WinScrolled" }, {
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
end
