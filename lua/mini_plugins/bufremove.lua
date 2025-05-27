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

local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<leader>bd", "<cmd>lua bufdelete()<cr>", { desc = "Delete" })
map("n", "<leader>bw", "<cmd>lua bufwipeout()<cr>", { desc = "Wipeout" })
