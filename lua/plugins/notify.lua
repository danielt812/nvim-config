local M = { "rcarriga/nvim-notify" }

M.enabled = false

M.event = { "VimEnter" }

M.opts = function()
  return {
    level = vim.log.levels.INFO,
    timeout = 5000,
    max_width = nil,
    max_height = nil,
    stages = "fade_in_slide_out", -- fade, slide, fade_in_slide_out, static
    render = "compact", -- default, minimal, simple, compact
    background_colour = "#000000",
    on_open = nil,
    on_close = nil,
    minimum_width = 50,
    fps = 30,
    top_down = true,
    time_formats = {
      notification_history = "%FT%T",
      notification = "%T",
    },
    icons = {
      ERROR = " ",
      WARN = " ",
      INFO = " ",
      DEBUG = " ",
      TRACE = "✎ ",
    },
  }
end

M.config = function(_, opts)
  require("notify").setup(opts)
  vim.notify = require("notify")
end

return M
