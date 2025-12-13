local bufremove = require("mini.bufremove")
local starter = require("mini.starter")

bufremove.setup({
  use_vim_settings = true,
  silent = false,
})

local open_starter_if_empty_buffer = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  -- stylua: ignore
  if not is_empty then return end

  starter.open()
  vim.cmd(buf_id .. "bwipeout")
end

local bufdelete = function(...)
  bufremove.delete(...)
  open_starter_if_empty_buffer()
end

local bufwipeout = function(...)
  bufremove.wipeout(...)
  open_starter_if_empty_buffer()
end

local delete_buffers = function(action, mode, opts)
  opts = opts or {}
  local force = opts.force or false

  if mode ~= "others" and mode ~= "left" and mode ~= "right" then
    vim.notify("Invalid mode for delete_buffers: " .. tostring(mode), vim.log.levels.ERROR)
    return
  end

  local cur = vim.api.nvim_get_current_buf()

  local function deletable(buf)
    -- Skip current buffer
    if buf == cur then
      return false
    end
    -- Skip unlisted buffers
    if vim.fn.buflisted(buf) ~= 1 then
      return false
    end

    local bt = vim.bo[buf].buftype
    -- Skip special buffers unless force=true
    if not force and (bt == "terminal" or bt == "quickfix" or bt == "nofile" or bt == "help" or bt == "prompt") then
      return false
    end

    return true
  end

  -- All buffers in numerical order
  local bufs = vim.api.nvim_list_bufs()

  -- Find index of current buffer
  local cur_index
  for i, buf in ipairs(bufs) do
    if buf == cur then
      cur_index = i
      break
    end
  end

  if not cur_index then
    vim.notify("Could not determine current buffer index", vim.log.levels.WARN)
    return
  end

  -- Apply deletion depending on mode
  for i, buf in ipairs(bufs) do
    local delete = false

    if mode == "others" then
      delete = (buf ~= cur)
    elseif mode == "left" then
      delete = (i < cur_index)
    elseif mode == "right" then
      delete = (i > cur_index)
    end

    if delete and deletable(buf) then
      if action == "delete" then
        bufremove.delete(buf, force)
      elseif action == "wipeout" then
        bufremove.wipeout(buf, force)
      end
    end
  end
end

local bufdelete_others = function(opts)
  return delete_buffers("delete", "others", opts)
end
local bufdelete_left = function(opts)
  return delete_buffers("delete", "left", opts)
end
local bufdelete_right = function(opts)
  return delete_buffers("delete", "right", opts)
end

-- local bufwipeout_others = function(opts) return delete_buffers("wipeout", "others", opts) end
-- local bufwipeout_left   = function(opts) return delete_buffers("wipeout", "left", opts) end
-- local bufwipeout_right  = function(opts) return delete_buffers("wipeout", "right", opts) end

-- stylua: ignore start
vim.keymap.set("n", "<leader>bc", bufdelete,        { desc = "Delete Current" })
vim.keymap.set("n", "<leader>bo", bufdelete_others, { desc = "Delete Others" })
vim.keymap.set("n", "<leader>bh", bufdelete_left,   { desc = "Delete Left" })
vim.keymap.set("n", "<leader>bl", bufdelete_right,  { desc = "Delete Right" })

-- vim.keymap.set("n", "<leader>bwc", bufwipeout,        { desc = "Current" })
-- vim.keymap.set("n", "<leader>bwo", bufwipeout_others, { desc = "Others" })
-- vim.keymap.set("n", "<leader>bwh", bufwipeout_left,   { desc = "Left" })
-- vim.keymap.set("n", "<leader>bwl", bufwipeout_right,  { desc = "Right" })
-- stylua: ignore end
