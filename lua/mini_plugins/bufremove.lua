local bufremove = require("mini.bufremove")

bufremove.setup({
  use_vim_settings = true,
  silent = false,
})

local function open_starter_if_empty_buffer()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""

  if not is_empty then
    return
  end

  local ok, starter = pcall(require, "mini.starter")
  if ok then
    starter.open()
    vim.cmd(buf_id .. "bwipeout")
  end
end

local function bufdelete(...)
  bufremove.delete(...)
  open_starter_if_empty_buffer()
end

local function bufwipeout(...)
  bufremove.wipeout(...)
  open_starter_if_empty_buffer()
end

local function remove_buffers(action, mode, opts)
  opts = opts or {}
  local force = opts.force or false

  if mode ~= "others" and mode ~= "left" and mode ~= "right" then
    vim.notify("Invalid mode for remove_buffers: " .. tostring(mode), vim.log.levels.ERROR)
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

-- stylua: ignore start
local function bufdelete_others(opts) remove_buffers("delete", "others", opts) end
local function bufdelete_left(opts) remove_buffers("delete", "left", opts) end
local function bufdelete_right(opts) remove_buffers("delete", "right", opts) end
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<leader>bd", bufdelete, { desc = "Delete Current" })
vim.keymap.set("n", "<leader>bo", bufdelete_others, { desc = "Delete Others" })
vim.keymap.set("n", "<leader>bh", bufdelete_left, { desc = "Delete Left" })
vim.keymap.set("n", "<leader>bl", bufdelete_right, { desc = "Delete Right" })
vim.keymap.set("n", "<leader>bw", bufwipeout, { desc = "Wipeout" })
-- stylua: ignore end
