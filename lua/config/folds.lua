-- #############################################################################
-- #                               Fold Text                                   #
-- #############################################################################

local ns = vim.api.nvim_create_namespace("folds.foldtext")

-- Read treesitter extmark highlights off a buffer line → {text, hl}[] chunks
local function ts_chunks(buf, lnum)
  local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ""
  if line == "" then return { { "", "Normal" } } end

  local ts_ns = vim.treesitter.highlighter.hl_ns
  if not ts_ns then return { { line, "Normal" } } end

  local len   = #line
  local marks = vim.api.nvim_buf_get_extmarks(buf, ts_ns, { lnum, 0 }, { lnum, -1 }, {
    details = true,
    overlap = true,
  })

  local hl_at = {}
  for _, mark in ipairs(marks) do
    local col = mark[3]
    local d   = mark[4]
    if not d.hl_group then goto continue end
    local end_col = (d.end_row and d.end_row > lnum) and len or math.min(d.end_col or len, len)
    local pri = d.priority or 100
    for i = math.max(col, 0), end_col - 1 do
      if not hl_at[i] or pri >= hl_at[i][2] then hl_at[i] = { d.hl_group, pri } end
    end
    ::continue::
  end

  local chunks, cur_hl, cur_start = {}, nil, 0
  for i = 0, len - 1 do
    local hl = hl_at[i] and hl_at[i][1] or "Normal"
    if hl ~= cur_hl then
      if cur_hl then table.insert(chunks, { line:sub(cur_start + 1, i), cur_hl }) end
      cur_hl, cur_start = hl, i
    end
  end
  table.insert(chunks, { line:sub(cur_start + 1), cur_hl or "Normal" })
  return chunks
end

local function strip_indent(chunks)
  local result, done = {}, false
  for _, chunk in ipairs(chunks) do
    if done then
      table.insert(result, chunk)
    else
      local stripped = chunk[1]:gsub("^%s+", "")
      if stripped ~= "" then
        done = true
        table.insert(result, { stripped, chunk[2] })
      end
    end
  end
  return result
end

vim.opt.fillchars:append({ fold = " " })

for _, winid in pairs(vim.api.nvim_list_wins()) do
  vim.wo[winid].foldtext = ""
end

vim.api.nvim_create_autocmd("WinNew", {
  desc = "Set foldtext in all windows",
  callback = function(ctx)
    local winid = vim.fn.bufwinid(ctx.buf)
    vim.wo[winid].foldtext = ""
  end,
})

local function render_fold(win, buf, foldstart)
  local foldend    = vim.fn.foldclosedend(foldstart)
  local count_text = (" %d lines"):format(foldend - foldstart)

  -- foldend is 1-indexed; foldend in 0-indexed is the line *after* the fold
  local end_chunks = strip_indent(ts_chunks(buf, foldend))

  local virt_text = { { " ... ", "Folded" } }
  vim.list_extend(virt_text, end_chunks)
  table.insert(virt_text, { count_text, "Comment" })

  local line    = vim.api.nvim_buf_get_lines(buf, foldstart - 1, foldstart, false)[1]
  local wininfo = vim.fn.getwininfo(win)[1] ---@diagnostic disable-line: undefined-field
  local leftcol = wininfo and wininfo.leftcol or 0 ---@diagnostic disable-line: undefined-field
  local wincol  = math.max(0, vim.fn.virtcol({ foldstart, line:len() }) - leftcol)

  vim.api.nvim_buf_set_extmark(buf, ns, foldstart - 1, 0, {
    virt_text         = virt_text,
    virt_text_win_col = wincol,
    hl_mode           = "combine",
    ephemeral         = true,
  })

  return foldend
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, win, buf, topline, botline)
    vim.api.nvim_win_call(win, function()
      local line = topline
      while line <= botline do
        local foldstart = vim.fn.foldclosed(line)
        if foldstart > -1 then line = render_fold(win, buf, foldstart) end
        line = line + 1
      end
    end)
  end,
})

-- #############################################################################
-- #                              Fold Method                                  #
-- #############################################################################

local function check_for_lsp(bufnr, client_id)
  if not bufnr then bufnr = 0 end
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].diff then return end

  local folding_clients = vim.lsp.get_clients({ bufnr = bufnr, id = client_id, method = "textDocument/foldingRange" })
  if #folding_clients == 0 then return end
  vim.api.nvim_buf_call(bufnr, function()
    vim.wo[win][0].foldmethod = "expr"
    vim.wo[win][0].foldexpr   = "v:lua.vim.lsp.foldexpr()"
    vim.b[bufnr].folding_provider = "lsp"
  end)
end

local function check_for_treesitter(bufnr, filetype)
  if not bufnr then bufnr = 0 end
  if vim.b[bufnr].folding_provider == "lsp" then return end
  local win = vim.api.nvim_get_current_win()
  if vim.wo[win].diff then return end

  if not filetype then filetype = vim.bo[bufnr].filetype end
  local ok, has_folds = pcall(vim.treesitter.query.get, filetype, "folds")

  vim.api.nvim_buf_call(bufnr, function()
    if ok and has_folds then
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr   = "v:lua.vim.treesitter.foldexpr()"
      vim.b[bufnr].folding_provider = "treesitter"
    else
      vim.wo[win][0].foldmethod = "indent"
      vim.wo[win][0].foldexpr   = ""
      vim.b[bufnr].folding_provider = "indent"
    end
  end)
end

local group = vim.api.nvim_create_augroup("folds", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group    = group,
  desc     = "Use LSP as fold provider if client supports it",
  callback = function(ctx) check_for_lsp(ctx.buf, ctx.data.client_id) end,
})

vim.api.nvim_create_autocmd("FileType", {
  group    = group,
  desc     = "Use treesitter as fold provider if there is a parser for it",
  callback = function(ctx) check_for_treesitter(ctx.buf, ctx.match) end,
})

for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
  check_for_lsp(buf.bufnr)
  check_for_treesitter(buf.bufnr)
end
