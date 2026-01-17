local bufremove = require("mini.bufremove")

bufremove.setup({
  use_vim_settings = true,
  silent = false,
})

--- Open starter page if the current buffer is empty
local function open_starter_if_empty_buffer()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""

  if not is_empty then
    return
  end

  local ok, starter = pcall(require, "mini.starter")

  if ok then
    starter.open()
    bufremove.wipeout(buf_id, true)
  end
end

--- Remove buffers by action and mode
--- @param action string
--- @param mode string
--- @param force boolean
local function remove_buffers(action, mode, force)
  local cur = vim.api.nvim_get_current_buf()

  local valid_actions = { delete = true, wipeout = true }

  if not valid_actions[action] then
    vim.notify("Invalid action: " .. action, vim.log.levels.ERROR)
  end

  local valid_modes = { all = true, current = true, others = true, left = true, right = true }

  if not valid_modes[mode] then
    vim.notify("Invalid mode: " .. mode, vim.log.levels.ERROR)
    return
  end

  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local bt = vim.bo[buf].buftype

    local deletable = vim.fn.buflisted(buf) == 1
      and (force or not vim.tbl_contains({ "terminal", "quickfix", "nofile", "help", "prompt" }, bt))

    local delete = mode == "all"
      or (mode == "current" and buf == cur)
      or (mode == "others" and buf ~= cur)
      or (mode == "left" and buf < cur)
      or (mode == "right" and buf > cur)

    if deletable and delete then
      bufremove[action](buf, force)
    end
  end

  open_starter_if_empty_buffer()
end

-- stylua: ignore start
local function bufdelete_all()    remove_buffers("delete",  "all",     false) end
local function bufdelete_cur()    remove_buffers("delete",  "current", false) end
local function bufdelete_left()   remove_buffers("delete",  "left",    false) end
local function bufdelete_others() remove_buffers("delete",  "others",  false) end
local function bufdelete_right()  remove_buffers("delete",  "right",   false) end
local function bufwipeout_cur()   remove_buffers("wipeout", "current", false) end
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<leader>ba", bufdelete_all,    { desc = "Delete All" })
vim.keymap.set("n", "<leader>bd", bufdelete_cur,    { desc = "Delete" })
vim.keymap.set("n", "<leader>bh", bufdelete_left,   { desc = "Delete Left" })
vim.keymap.set("n", "<leader>bl", bufdelete_right,  { desc = "Delete Right" })
vim.keymap.set("n", "<leader>bo", bufdelete_others, { desc = "Delete Others" })
vim.keymap.set("n", "<leader>bw", bufwipeout_cur,   { desc = "Wipeout" })
-- stylua: ignore end
