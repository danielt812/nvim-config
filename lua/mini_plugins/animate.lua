local animate = require("mini.animate")

local duration = 100

animate.setup({
  cursor = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),

    -- Animate with shortest line for any cursor move
    path = animate.gen_path.line({
      predicate = function(args)
        local delta_line = math.abs(args[1] or 0)
        local delta_col = math.abs(args[2] or 0)
        if delta_line == 1 and delta_col == 0 then return false end
        if delta_col == 1 and delta_line == 0 then return false end
        return true
      end,
    }),
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

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local toggle_animate = function()
  vim.b.minianimate_disable = not vim.b.minianimate_disable
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "<leader>\\a", toggle_animate, { desc = "Animate" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_animate", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniAnimateDoneScroll",
  group = group,
  desc = "Center after scroll",
  callback = function() vim.cmd("normal! zvzz") end,
})
