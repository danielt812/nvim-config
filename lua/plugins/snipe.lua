local snipe = require("snipe")
local utils = require("utils")

-- Setup Snipe
snipe.setup({
  ui = {
    open_win_override = {
      title = " Snipe ",
      border = "single",
    },
  },
})

local menu = require("snipe.menu"):new()
local items

-- Other default mappings can be set here too
local set_keymaps = function(m)
  vim.keymap.set("n", "<esc>", function()
    m:close()
  end, { nowait = true, buffer = m.buf })
end

menu:add_new_buffer_callback(set_keymaps)

-- Global access
_G.Snipe = snipe

local get_local_marks = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local marks = vim.fn.getmarklist(bufnr)
  items = {}

  for _, m in ipairs(marks) do
    local mark = string.sub(m.mark, 2, 2)
    if mark:match("^[a-z]$") then
      local lnum, col = m.pos[2], m.pos[3]
      local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""
      table.insert(items, {
        name = string.format("'%s  %4d:%-2d  %s", mark, lnum, col - 1, vim.trim(line):sub(1, 80)),
        lnum = lnum,
        col = col,
        buf = bufnr,
      })
    end
  end

  return items
end

utils.map("n", "<leader>so", function()
  items = require("snipe.buffer").get_buffers()
  menu.config.open_win_override.title = " Open "
  menu:open(items, function(m, i)
    m:close()
    vim.api.nvim_set_current_buf(m.items[i].id)
  end, function(item)
    return item.name
  end)
end, { desc = "Select" })

utils.map("n", "<leader>sd", function()
  items = require("snipe.buffer").get_buffers()
  menu.config.open_win_override.title = " Delete "
  menu:open(items, function(m, i)
    local bufnr = m.items[i].id
    _G.bufdelete(bufnr, true)
    m:close()
  end, function(item)
    return item.name
  end)
end, { desc = "Delete" })

utils.map("n", "<leader>sm", function()
  items = get_local_marks()
  if vim.tbl_isempty(items) then
    vim.notify("No marks found", vim.log.levels.INFO)
    return
  end

  menu.config.open_win_override.title = " Marks "
  menu:open(items, function(m, i)
    local item = m.items[i]
    m:close()
    vim.api.nvim_set_current_buf(item.buf)
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
  end, function(item)
    return item.name
  end)
end, { desc = "Marks" })
