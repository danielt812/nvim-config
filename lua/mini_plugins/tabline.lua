local tabline = require("mini.tabline")
local pin = require("utils.buffer-pin")

tabline.setup({
  format = function(buf, label)
    local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

    local sep = (#listed_buffers > 0) and "" or ""

    local suffix = {}

    if vim.bo[buf].modified and pin.is_pinned(buf) then
      table.insert(suffix, "")
    elseif pin.is_pinned(buf) then
      table.insert(suffix, "")
    elseif vim.bo[buf].modified then
      table.insert(suffix, "●")
    end

    if vim.bo[buf].readonly or not vim.bo[buf].modifiable then table.insert(suffix, "") end
    if vim.bo[buf].buftype == "nofile" then table.insert(suffix, "") end

    local pad = #suffix > 0 and " " or ""
    return tabline.default_format(buf, label) .. table.concat(suffix, " ") .. pad .. sep
  end,
  tabpage_section = "right",
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

vim.keymap.set("n", "<leader>bp", pin.toggle, { desc = "Pin/Unpin" })

vim.o.showtabline = 0

-- for i = 1, 9 do
--   vim.keymap.set("n", "<leader>b" .. i, function()
--     local bufs = vim.fn.getbufinfo({ buflisted = 1 })
--     table.sort(bufs, function(a, b) return a.bufnr < b.bufnr end)
--     if bufs[i] then vim.api.nvim_set_current_buf(bufs[i].bufnr) end
--   end, { desc = "Goto " .. i })
-- end
