local tabline = require("mini.tabline")
local buf_utils = require("utils.buffer-pin")

tabline.setup({
  format = function(buf, label)
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

    local sep = (#listed_buffers > 0) and "" or ""

    local suffix = {}

    if vim.bo[buf].modified and buf_utils.is_pinned(buf) then
      table.insert(suffix, "")
    elseif buf_utils.is_pinned(buf) then
      table.insert(suffix, "")
    elseif vim.bo[buf].modified then
      table.insert(suffix, "●")
    end

    if vim.bo[buf].readonly or not vim.bo[buf].modifiable then
      table.insert(suffix, "")
    end

    return tabline.default_format(buf, label) .. table.concat(suffix, " ") .. " " .. sep
  end,
  tabpage_section = "right",
})

vim.keymap.set("n", "<leader>bp", buf_utils.toggle, { desc = "Pin/Unpin" })
