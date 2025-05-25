local M = { "echasnovski/mini.basics" }

M.enabled = true

M.event = { "VimEnter" }

M.opts = function()
  return {
    options = {
      basic = true,
      extra_ui = true,
      win_borders = "solid",
    },
    mappings = {
      basic = true,
      option_toggle_prefix = nil,
      windows = false,
      move_with_alt = true,
    },
    autocommands = {
      basic = false,
      relnum_in_visual_mode = false,
    },
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.basics").setup(opts)
end

return M
