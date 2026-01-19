local tabline = require("mini.tabline")
local pins = require("utils.buffer-pins")

tabline.setup({
  format = function(buf, label)
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

    local sep = (#listed_buffers > 0) and "" or ""

    local suffix = ""

    if vim.bo[buf].modified then
      suffix = "● "
    elseif vim.bo[buf].readonly or not vim.bo[buf].modifiable then
      suffix = " "
    end

    if pins.is_pinned(buf) then
      suffix = suffix .. " "
    end

    return tabline.default_format(buf, label) .. suffix .. sep
  end,
  tabpage_section = "right",
})

local function toggle_pinned()
  pins.toggle(vim.api.nvim_get_current_buf())
  vim.cmd("redrawtabline")
end

vim.keymap.set("n", "<leader>bp", toggle_pinned, { desc = "Pin/Unpin" })
