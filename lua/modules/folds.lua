-- #############################################################################
-- #                               Folds Module                                #
-- #############################################################################
--
-- Lightweight fold management module inspired by nvim-ufo and nvim-origami.
--
-- Features:
--   - Fold provider: LSP → treesitter → indent fallback
--   - Custom foldtext with treesitter syntax highlighting
--   - Fold preview in a floating window
--   - h/l keybindings for fold/unfold at cursor
--   - Pause/restore folds during search
--
-- Requires: Neovim >= 0.11, treesitter parsers for syntax-highlighted foldtext

local Folds = {}
local H = {}

Folds.setup = function(config)
  _G.Folds = Folds

  config = H.setup_config(config)

  H.apply_config(config)
end

-- Defaults --------------------------------------------------------------------
Folds.config = {
  -- Providers in priority order: "lsp", "treesitter", "indent"
  provider = {
    "treesitter",
    "lsp",
    "indent",
  },

  -- Foldtext rendering
  foldtext = {
    -- Separator between first line and closing line content
    filling = " ... ",
    -- Suffix format: %d is replaced with fold line count
    suffix = " %d lines folded ",
    -- Highlight group for filling and suffix
    hl = "Folded",
    -- Whether to show the closing line content
    show_end_line = true,
    -- Whether to use treesitter highlights on fold text
    treesitter_hl = true,
  },

  -- Preview floating window
  preview = {
    -- Max height of the preview window
    max_height = 20,
    -- Border style
    border = "rounded",
  },

  -- h/l fold/unfold behavior
  hl_fold = {
    -- Enable h to fold at first non-blank, l to unfold
    enable = true,
  },

  -- Pause folds during search
  pause_on_search = {
    enable = true,
  },

  mappings = {
    -- Preview fold under cursor
    preview = "zp",
  },
}

-- Public API ------------------------------------------------------------------

--- Get the fold text for a given fold range (used as foldtext function)
Folds.foldtext = function()
  local config = H.get_config().foldtext
  local lnum = vim.v.foldstart
  local end_lnum = vim.v.foldend
  local line_count = end_lnum - lnum

  -- Build first line with treesitter highlights
  local virt_text = H.get_line_virt_text(lnum, config.treesitter_hl)

  -- Add filling
  table.insert(virt_text, { config.filling, config.hl })

  -- Add end line content
  if config.show_end_line then
    local end_text = H.get_line_virt_text(end_lnum, config.treesitter_hl)
    -- Trim leading whitespace from end line
    if #end_text > 0 then
      end_text[1][1] = end_text[1][1]:gsub("^%s+", "")
    end
    vim.list_extend(virt_text, end_text)
  end

  -- Add suffix
  local suffix = config.suffix:format(line_count)
  table.insert(virt_text, { suffix, config.hl })

  return virt_text
end

--- Preview the fold under the cursor in a floating window
Folds.preview = function()
  -- Close existing preview
  if H.preview_win and vim.api.nvim_win_is_valid(H.preview_win) then
    vim.api.nvim_win_close(H.preview_win, true)
    H.preview_win = nil
    return
  end

  local lnum = vim.fn.foldclosed(".")
  if lnum == -1 then return end
  local end_lnum = vim.fn.foldclosedend(".")

  local config = H.get_config().preview
  local lines = vim.api.nvim_buf_get_lines(0, lnum - 1, end_lnum, false)
  local height = math.min(#lines, config.max_height)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = vim.bo.filetype
  vim.bo[buf].bufhidden = "wipe"

  H.preview_win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = math.min(vim.api.nvim_win_get_width(0) - 4, H.max_line_width(lines) + 2),
    height = height,
    style = "minimal",
    border = config.border,
    title = (" %d lines "):format(end_lnum - lnum + 1),
    title_pos = "right",
  })
  vim.wo[H.preview_win].foldenable = false
  vim.wo[H.preview_win].winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder"

  -- Start treesitter in the preview buffer
  pcall(vim.treesitter.start, buf)

  -- Close on cursor move
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "WinLeave" }, {
    once = true,
    callback = function()
      if H.preview_win and vim.api.nvim_win_is_valid(H.preview_win) then
        vim.api.nvim_win_close(H.preview_win, true)
      end
      H.preview_win = nil
    end,
  })
end

--- Apply fold provider to a buffer
Folds.apply_provider = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].buftype ~= "" then return end

  local config = H.get_config()
  for _, provider in ipairs(config.provider) do
    if provider == "lsp" and H.has_lsp_folding(bufnr) then
      H.set_fold_method(bufnr, "expr", "v:lua.Folds.lsp_foldexpr()")
      return
    elseif provider == "treesitter" and H.has_treesitter(bufnr) then
      H.set_fold_method(bufnr, "expr", "v:lua.vim.treesitter.foldexpr()")
      return
    elseif provider == "indent" then
      H.set_fold_method(bufnr, "indent", nil)
      return
    end
  end
end

--- LSP-based foldexpr (wrapper around vim.lsp.foldexpr)
Folds.lsp_foldexpr = function()
  return vim.lsp.foldexpr()
end

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(Folds.config)
H.preview_win = nil
H.search_saved_views = {}

-- Helper: Config --------------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("provider", config.provider, "table")
  H.check_type("foldtext", config.foldtext, "table")
  H.check_type("foldtext.filling", config.foldtext.filling, "string")
  H.check_type("foldtext.suffix", config.foldtext.suffix, "string")
  H.check_type("foldtext.hl", config.foldtext.hl, "string")
  H.check_type("foldtext.show_end_line", config.foldtext.show_end_line, "boolean")
  H.check_type("foldtext.treesitter_hl", config.foldtext.treesitter_hl, "boolean")
  H.check_type("preview", config.preview, "table")
  H.check_type("hl_fold", config.hl_fold, "table")
  H.check_type("hl_fold.enable", config.hl_fold.enable, "boolean")
  H.check_type("pause_on_search", config.pause_on_search, "table")
  H.check_type("pause_on_search.enable", config.pause_on_search.enable, "boolean")
  H.check_type("mappings", config.mappings, "table")

  return config
end

H.apply_config = function(config)
  Folds.config = config

  -- Set global foldtext
  vim.o.foldtext = "v:lua.Folds.foldtext()"

  H.create_autocommands()
  H.create_mappings(config)
end

-- Helper: Autocommands --------------------------------------------------------
H.create_autocommands = function()
  local group = vim.api.nvim_create_augroup("Folds", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end

  -- Apply provider when LSP attaches
  au("LspAttach", "*", function(args)
    -- Defer to let the LSP client fully initialize
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        Folds.apply_provider(args.buf)
      end
    end, 100)
  end, "Apply fold provider on LSP attach")

  -- Apply provider on filetype (for treesitter/indent)
  au("FileType", "*", function(args)
    -- Skip if LSP already set foldexpr for this buffer
    local wins = vim.fn.win_findbuf(args.buf)
    local foldexpr = #wins > 0 and vim.api.nvim_get_option_value("foldexpr", { win = wins[1] }) or ""
    if foldexpr:find("lsp_foldexpr") then return end
    Folds.apply_provider(args.buf)
  end, "Apply fold provider on FileType")

  -- Pause/restore folds on search
  local config = Folds.config
  if config.pause_on_search.enable then
    au("CmdlineEnter", "/,?", function()
      H.save_fold_views()
      vim.cmd("silent! %foldopen!")
    end, "Open all folds on search start")

    au("CmdlineLeave", "/,?", function()
      -- Defer to allow the search to complete
      vim.schedule(function()
        H.restore_fold_views()
      end)
    end, "Restore folds on search end")
  end
end

-- Helper: Mappings ------------------------------------------------------------
H.create_mappings = function(config)
  H.map("n", config.mappings.preview, Folds.preview, { desc = "Preview fold" })

  if config.hl_fold.enable then
    H.map("n", "h", H.smart_h, { desc = "Smart fold h" })
    H.map("n", "l", H.smart_l, { desc = "Smart fold l" })
  end
end

-- Helper: Smart h/l -----------------------------------------------------------
H.smart_h = function()
  local col = vim.fn.col(".")
  local first_non_blank = vim.fn.indent(".") + 1
  if col <= first_non_blank and vim.fn.foldlevel(".") > 0 then
    vim.cmd("silent! foldclose")
  else
    vim.cmd("normal! h")
  end
end

H.smart_l = function()
  if vim.fn.foldclosed(".") ~= -1 then
    vim.cmd("silent! foldopen")
  else
    vim.cmd("normal! l")
  end
end

-- Helper: Fold providers ------------------------------------------------------
H.has_lsp_folding = function(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/foldingRange") then
      return true
    end
  end
  return false
end

H.has_treesitter = function(bufnr)
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then return false end
  local ok = pcall(vim.treesitter.get_parser, bufnr, lang)
  return ok
end

H.set_fold_method = function(bufnr, method, expr)
  local wins = vim.fn.win_findbuf(bufnr)
  if #wins == 0 then return end
  for _, win in ipairs(wins) do
    vim.api.nvim_set_option_value("foldmethod", method, { win = win })
    if expr then vim.api.nvim_set_option_value("foldexpr", expr, { win = win }) end
  end
end

-- Helper: Foldtext rendering --------------------------------------------------
H.get_line_virt_text = function(lnum, use_ts)
  local line = vim.fn.getline(lnum)
  if not use_ts then
    return { { line, "Folded" } }
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return { { line, "Folded" } }
  end

  -- Get treesitter highlights for the line
  local result = {}
  local row = lnum - 1

  -- Collect all captures for this line
  local captures = {}
  parser:for_each_tree(function(tstree, ltree)
    local query = vim.treesitter.query.get(ltree:lang(), "highlights")
    if not query then return end
    local root = tstree:root()
    local root_start, _, root_end = root:range()
    if row < root_start or row > root_end then return end

    for id, node, metadata in query:iter_captures(root, bufnr, row, row + 1) do
      local sr, sc, er, ec = node:range()
      -- Only captures that touch our line
      if sr <= row and er >= row then
        local start_col = sr < row and 0 or sc
        local end_col = er > row and #line or ec
        local name = query.captures[id]
        -- Skip underscore-prefixed captures (predicates)
        if not name:match("^_") then
          local priority = (metadata and metadata.priority) or tonumber(name:match("^(%d+)")) or 100
          table.insert(captures, { start_col = start_col, end_col = end_col, hl = "@" .. name, priority = priority })
        end
      end
    end
  end)

  -- Sort by start position, then by priority (higher wins)
  table.sort(captures, function(a, b)
    if a.start_col ~= b.start_col then return a.start_col < b.start_col end
    return a.priority > b.priority
  end)

  -- Build virtual text chunks from captures
  if #captures == 0 then
    return { { line, "Folded" } }
  end

  -- Flatten overlapping captures: for each column, pick highest priority
  local col_hl = {}
  for _, cap in ipairs(captures) do
    for c = cap.start_col, cap.end_col - 1 do
      if not col_hl[c] or cap.priority > col_hl[c].priority then
        col_hl[c] = cap
      end
    end
  end

  -- Build contiguous chunks
  local i = 0
  while i < #line do
    local cap = col_hl[i]
    local hl = cap and cap.hl or "Folded"
    local j = i + 1
    while j < #line do
      local next_cap = col_hl[j]
      local next_hl = next_cap and next_cap.hl or "Folded"
      if next_hl ~= hl then break end
      j = j + 1
    end
    table.insert(result, { line:sub(i + 1, j), hl })
    i = j
  end

  return #result > 0 and result or { { line, "Folded" } }
end

-- Helper: Fold views for search -----------------------------------------------
H.save_fold_views = function()
  H.search_saved_views = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    H.search_saved_views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
  end
end

H.restore_fold_views = function()
  for win, view in pairs(H.search_saved_views) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function() vim.fn.winrestview(view) end)
    end
  end
  H.search_saved_views = {}
end

-- Helper: Preview -------------------------------------------------------------
H.max_line_width = function(lines)
  local max = 0
  for _, line in ipairs(lines) do
    local w = vim.fn.strdisplaywidth(line)
    if w > max then max = w end
  end
  return max
end

-- Helper: Utils ---------------------------------------------------------------
H.error = function(msg) error("(modules.folds) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

H.get_config = function(config)
  return vim.tbl_deep_extend("force", Folds.config, vim.b.folds_config or {}, config or {})
end

return Folds
