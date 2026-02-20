local bufremove = require("mini.bufremove")
local pin = require("utils.buffer-pin")

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local open_starter_if_empty_buffer = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then return end

  local starter = require("mini.starter")
  starter.open()
  bufremove.wipeout(buf_id, true)
end

--- Remove one or many buffers
--- @param action? '"delete"'|'"wipeout"'
--- @param selection? '"all"'|'"current"'|'"others"'|'"left"'|'"right"'|'"unpinned"'
--- @param force boolean?
local remove_buffers = function(action, selection, force)
  action = action or "delete"
  selection = selection or "current"
  force = force or false

  local cur = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    local delete = selection == "all"
      or (selection == "current" and buf == cur)
      or (selection == "others" and buf ~= cur)
      or (selection == "left" and buf < cur)
      or (selection == "right" and buf > cur)

    if vim.fn.buflisted(buf) == 1 and delete and not pin.is_pinned(buf) then bufremove[action](buf, force) end
  end

  open_starter_if_empty_buffer()
end

-- stylua: ignore start
local bufdelete_cur    = function() remove_buffers("delete",  "current", false) end
local bufdelete_others = function() remove_buffers("delete",  "others",  false) end
local bufdelete_all    = function() remove_buffers("delete",  "all",     false) end
local bufdelete_left   = function() remove_buffers("delete",  "left",    false) end
local bufdelete_right  = function() remove_buffers("delete",  "right",   false) end
local bufwipeout_cur   = function() remove_buffers("wipeout", "current", true)  end
-- stylua: ignore end


-- stylua: ignore start
vim.keymap.set("n", "<leader>bd", bufdelete_cur,    { desc = "Delete" })
vim.keymap.set("n", "<leader>ba", bufdelete_all,    { desc = "Delete All" })
vim.keymap.set("n", "<leader>bh", bufdelete_left,   { desc = "Delete Left" })
vim.keymap.set("n", "<leader>bl", bufdelete_right,  { desc = "Delete Right" })
vim.keymap.set("n", "<leader>bo", bufdelete_others, { desc = "Delete Others" })
vim.keymap.set("n", "<leader>bw", bufwipeout_cur,   { desc = "Wipeout!" })
-- stylua: ignore end
