local tabline = require("mini.tabline")

tabline.setup({
  format = function(buf_id, label)
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

    local sep = (#listed_buffers > 0) and "" or ""

    local suffix = ""

    if vim.bo[buf_id].modified then
      suffix = "● "
    elseif vim.bo[buf_id].readonly or not vim.bo[buf_id].modifiable then
      suffix = " "
    end

    return tabline.default_format(buf_id, label) .. suffix .. sep
  end,
  tabpage_section = "right",
})
