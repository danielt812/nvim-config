local trailspace = require("mini.trailspace")

trailspace.setup({
  only_in_normal_buffers = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("mini_trailspace_trim_on_save", { clear = true }),
  pattern = "*",
  callback = function()
    trailspace.trim()
  end,
})
