local trailspace = require("mini.trailspace")

trailspace.setup({
  only_in_normal_buffers = true,
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_trailspace", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = group,
  desc = "Trim trailing whitespace on save",
  callback = function()
    trailspace.trim()
  end,
})
