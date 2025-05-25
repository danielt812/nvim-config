local M = { "echasnovski/mini.animate" }

M.enabled = true

M.event = { "BufRead", "BufEnter" }

M.opts = function()
  local animate = require("mini.animate")
  return {
    -- Cursor path
    cursor = {
      -- Whether to enable this animation
      enable = false,
      timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
    },

    -- Vertical scroll
    scroll = {
      -- Whether to enable this animation
      enable = true,
      timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
      -- subscroll = animate.gen_subscroll.equal({ max_output_steps = 120 }),
    },

    -- Window resize
    resize = {
      -- Whether to enable this animation
      enable = true,
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
    },

    -- Window open
    open = {
      -- Whether to enable this animation
      enable = true,
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
    },

    -- Window close
    close = {
      -- Whether to enable this animation
      enable = true,
      timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
    },
  }
end

M.config = function(_, opts)
  local animate = require("mini.animate")

  local mini_au_group = vim.api.nvim_create_augroup("mini_au_group", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = mini_au_group,
    pattern = "MiniAnimateDoneScroll",
    desc = "Auto zz after scroll",
    callback = function()
      vim.cmd("normal! zvzz")
    end,
  })

  animate.setup(opts)
end

return M
