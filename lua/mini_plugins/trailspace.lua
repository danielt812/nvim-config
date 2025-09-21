local trailspace = require("mini.trailspace")

trailspace.setup({
  only_in_normal_buffers = true,
})

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("BufWritePre", {
  group = augroup("minitrail_space_trim_on_save", { clear = true }),
  pattern = "*",
  callback = function()
    trailspace.trim()
  end,
})
