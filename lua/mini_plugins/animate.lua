local animate = require("mini.animate")

local duration = 100

animate.setup({
  cursor = {
    -- Using smear Cursor
    enable = false,
  },
  scroll = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
  resize = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
  open = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
  close = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
})

local au = vim.api.nvim_create_autocmd
local au_group = vim.api.nvim_create_augroup

local group = au_group("mini_animate", { clear = true })

au("User", {
  group = group,
  pattern = "MiniAnimateDoneScroll",
  desc = "Center after scroll",
  callback = function()
    vim.cmd("normal! zvzz")
  end,
})
