local jump = require("mini.jump")

jump.setup({
  mappings = {
    forward = "f",
    backward = "F",
    forward_till = "t",
    backward_till = "T",
    repeat_jump = "",
  },
  delay = {
    highlight = 250,
    idle_stop = 10000000,
  },
  silent = false,
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, ";", function() jump.jump(nil, false, nil, vim.v.count1) end)
vim.keymap.set({ "n", "x", "o" }, ",", function() jump.jump(nil, true,  nil, vim.v.count1) end)
-- stylua: ignore end

vim.on_key(function(_, key)
  if jump.state.jumping and key == vim.keycode("<esc>") then jump.stop_jumping() end
end, vim.api.nvim_create_namespace("mini_jump_esc"))

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function gen_hl_groups() vim.api.nvim_set_hl(0, "MiniJumpDim", { link = "NonText" }) end

gen_hl_groups() -- Call this now if colorscheme was already set

local dim_match_ids = {}

local function find_boundary(line, search, backward, ignore_case)
  if backward then
    local lines = vim.api.nvim_buf_get_lines(0, 0, line - 1, false)
    for i = #lines, 1, -1 do
      local l = ignore_case and lines[i]:lower() or lines[i]
      if l:find(search, 1, true) then return i end
    end
  else
    local lines = vim.api.nvim_buf_get_lines(0, line, -1, false)
    for i = 1, #lines do
      local l = ignore_case and lines[i]:lower() or lines[i]
      if l:find(search, 1, true) then return line + i end
    end
  end
end

local function clear_dim_matches()
  for _, id in ipairs(dim_match_ids) do
    pcall(vim.fn.matchdelete, id)
  end
  dim_match_ids = {}
end

local function add_dim_matches(line, boundary, backward)
  local ids = {}
  local function add(pat) ids[#ids + 1] = vim.fn.matchadd("MiniJumpDim", pat, 11) end
  if backward then
    add(string.format([[\%%>%dl]], line))
    if boundary > 1 then add(string.format([[\%%<%dl]], boundary)) end
  else
    add(string.format([[\%%<%dl]], line))
    if boundary < vim.api.nvim_buf_line_count(0) then add(string.format([[\%%>%dl]], boundary)) end
  end
  return ids
end

local function apply_dim()
  clear_dim_matches()
  local line = vim.fn.line(".")
  local target = jump.state.target
  if not target then return end

  local backward = jump.state.backward
  local ignore_case = vim.o.ignorecase and (not vim.o.smartcase or target == target:lower())
  local search = ignore_case and target:lower() or target
  local boundary = find_boundary(line, search, backward, ignore_case)
  if not boundary then return end

  dim_match_ids = add_dim_matches(line, boundary, backward)
end

local function jump_dim_cb() vim.schedule(apply_dim) end

local jump_undim_cb = clear_dim_matches

local function jump_stop_cb()
  if jump.state.jumping then jump.stop_jumping() end
end

local group = vim.api.nvim_create_augroup("mini_jump", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "no*:*",
  group = group,
  desc = "Stop jump mode after operator-pending mode keymaps",
  callback = jump_stop_cb,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniJumpJump",
  group = group,
  callback = jump_dim_cb,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniJumpStop",
  group = group,
  callback = jump_undim_cb,
})
