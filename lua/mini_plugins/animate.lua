local animate = require("mini.animate")

local duration = 100

animate.setup({
  cursor = {
    enable = false,
    -- Animate for 200 milliseconds with linear easing
    timing = animate.gen_timing.linear({ duration = 200, unit = "total" }),

    -- Animate with shortest line for any cursor move
    -- stylua: ignore
    path = animate.gen_path.line({ predicate = function() return true end }),
  },
  scroll = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({
      predicate = function(total_scroll)
        -- Skip animation if only 1 line up/down
        return math.abs(total_scroll) > 1
      end,
    }),
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

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("mini_animate", { clear = true }),
  pattern = "MiniAnimateDoneScroll",
  desc = "Center after scroll",
  callback = function()
    vim.cmd("normal! zvzz")
  end,
})
