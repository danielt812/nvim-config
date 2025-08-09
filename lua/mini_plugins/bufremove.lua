local bufremove = require("mini.bufremove")

bufremove.setup({
  use_vim_settings = true,
  silent = false,
})

local open_starter_if_empty_buffer = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
  if not is_empty then
    return
  end

  require("mini.starter").open()
  vim.cmd(buf_id .. "bwipeout")
end

_G.bufdelete = function(...)
  bufremove.delete(...)
  open_starter_if_empty_buffer()
end

_G.bufwipeout = function(...)
  bufremove.wipeout(...)
  open_starter_if_empty_buffer()
end

_G.bufdelete_others = function(opts)
  opts = opts or {}
  local force = opts.force or false

  local cur = vim.api.nvim_get_current_buf()

  local function deletable(buf)
    if buf == cur then
      return false
    end
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

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if deletable(buf) then
      -- mini.bufremove respects modified buffers (won't kill unless force=true)
      bufremove.delete(buf, force)
    end
  end

  -- If we ended up on an empty buffer, show Starter
  open_starter_if_empty_buffer()
end

local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>bd", "<cmd>lua bufdelete()<cr>", { desc = "Delete Current" })
map("n", "<leader>bw", "<cmd>lua bufwipeout()<cr>", { desc = "Wipeout Current" })
map("n", "<leader>bo", "<cmd>lua bufdelete_others()<cr>", { desc = "Delete Others" })
