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
  print(vim.inspect(...))
  bufremove.delete(...)
  open_starter_if_empty_buffer()
end

local bufwipeout = function(...)
  bufremove.wipeout(...)
  open_starter_if_empty_buffer()
end

local bufdelete_others = function(opts)
  opts = opts or {}
  local force = opts.force or false

  local cur = vim.api.nvim_get_current_buf()

  local function deletable(buf)
    -- stylua: ignore start
    if buf == cur then return false end
    if vim.fn.buflisted(buf) ~= 1 then return false end
    -- stylua: ignore end

    local bt = vim.bo[buf].buftype
    -- Skip special buffers unless force=true
    -- stylua: ignore
    if not force and (bt == "terminal" or bt == "quickfix" or bt == "nofile" or bt == "help" or bt == "prompt") then return false end
    return true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- mini.bufremove respects modified buffers (won't kill unless force=true)
    -- stylua: ignore
    if deletable(buf) then bufremove.delete(buf, force) end
  end

  -- If we ended up on an empty buffer, show Starter
  open_starter_if_empty_buffer()
end

vim.keymap.set("n", "<leader>bd", bufdelete, { desc = "Delete Current" })
vim.keymap.set("n", "<leader>bw", bufwipeout, { desc = "Wipeout Current" })
vim.keymap.set("n", "<leader>bo", bufdelete_others, { desc = "Delete Others" })
