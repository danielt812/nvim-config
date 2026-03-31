-- #############################################################################
-- #                                   Marks                                   #
-- #############################################################################

local ns_id = vim.api.nvim_create_namespace("marks")

local function clear_ns(buf_id) vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1) end

local function place_extmarks(marks, buf_id, scope)
  for _, m in ipairs(marks) do
    local char = m.mark:sub(-1)
    local lnum = m.pos[2]
    if lnum == 0 then goto continue end
    local opts = { sign_text = char, sign_hl_group = "MarksSign", priority = 3 }
    -- stylua: ignore start
    if scope == "global" then vim.api.nvim_buf_set_extmark(buf_id, ns_id, lnum - 1, 0, opts) end
    if scope == "local"  then vim.api.nvim_buf_set_extmark(buf_id, ns_id, lnum - 1, 0, opts) end
    -- stylua: ignore end
    ::continue::
  end
end

local function apply_extmarks()
  local buf_id = vim.api.nvim_get_current_buf()
  clear_ns(buf_id)
  -- stylua: ignore start
  local global_marks = vim.tbl_filter(function(m) return m.mark:sub(-1):match("^[A-Z]$") and m.pos[1] == buf_id end, vim.fn.getmarklist())
  local local_marks = vim.tbl_filter(function(m) return m.mark:sub(-1):match("^[a-z]$") end, vim.fn.getmarklist(buf_id))
  place_extmarks(global_marks, buf_id, "global")
  place_extmarks(local_marks,  buf_id, "local")
  -- stylua: ignore end
end

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function delete_mark()
  local char = vim.fn.getcharstr()
  vim.api.nvim_buf_del_mark(vim.api.nvim_get_current_buf(), char)
  apply_extmarks()
end

local function set_mark()
  local char = vim.fn.getcharstr()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_mark(0, char, row, col, {})
end

-- Quickfix / Loclist ----------------------------------------------------------

local function marks_to_list_items()
  local buf_id = vim.api.nvim_get_current_buf()
  local marks = vim.fn.getmarklist(buf_id)

  local items = {}
  for _, m in ipairs(marks) do
    local char = m.mark:sub(-1)
    local bufnr, lnum, col = m.pos[1], m.pos[2], m.pos[3]
    if lnum ~= 0 and char:match("^[a-z]$") then
      table.insert(items, { bufnr = bufnr, lnum = lnum, col = (col or 0) + 1, text = "mark " .. char })
    end
  end

  table.sort(items, function(a, b)
    if a.lnum ~= b.lnum then return a.lnum < b.lnum end
    return a.col < b.col
  end)

  return items
end

local function send_marks_to_qf()
  local items = marks_to_list_items()
  vim.fn.setqflist({}, "r", { title = "Marks", items = items })
  if #items > 0 then vim.cmd("copen") end
end

local function send_marks_to_loc()
  local items = marks_to_list_items()
  vim.fn.setloclist(0, {}, "r", { title = "Marks (loclist)", items = items })
  if #items > 0 then vim.cmd("lopen") end
end

-- stylua: ignore start
vim.keymap.set("n", "dm",         delete_mark,       { desc = "Delete mark" })
vim.keymap.set("n", "m",          set_mark,          { desc = "Set mark" })
vim.keymap.set("n", "<leader>qm", send_marks_to_qf,  { desc = "Marks (QF)" })
vim.keymap.set("n", "<leader>qM", send_marks_to_loc, { desc = "Marks (Loc)" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function gen_hl_groups() vim.api.nvim_set_hl(0, "MarksSign", { link = "Constant" }) end

gen_hl_groups() -- Call this now if colorscheme was already set

local group = vim.api.nvim_create_augroup("marks", { clear = true })

vim.api.nvim_create_autocmd("MarkSet", {
  group = group,
  pattern = "*",
  desc = "Refresh mark signs when a mark is set",
  callback = function() vim.schedule(apply_extmarks) end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  desc = "Set mark extmarks on buffer enter",
  callback = apply_extmarks,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})

apply_extmarks()
