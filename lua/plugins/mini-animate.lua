local M = { "echasnovski/mini.animate" }

M.enabled = false

M.event = { "BufReadPre" }

M.opts = function()
  local animate = require("mini.animate")
  return {
    -- Cursor path
    cursor = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Vertical scroll
    scroll = {
      -- Whether to enable this animation
      enable = true,
      animate.execute_after("scroll", "normal! zvzz"),
    },

    -- Window resize
    resize = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Window open
    open = {
      -- Whether to enable this animation
      enable = true,
    },

    -- Window close
    close = {
      -- Whether to enable this animation
      enable = true,
    },
  }
end

M.config = function(_, opts)
  require("mini.animate").setup(opts)
end

return M
