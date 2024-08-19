local M = { "echasnovski/mini.basics" }

M.enabled = false

M.event = { "VeryLazy" }

M.opts = function()
  return {
    -- Options. Set to `false` to disable.
    options = {
      -- Basic options ('number', 'ignorecase', and many more)
      basic = false,

      -- Extra UI features ('winblend', 'cmdheight=0', ...)
      extra_ui = false,

      -- Presets for window borders ('single', 'double', ...)
      win_borders = "default",
    },

    -- Mappings. Set to `false` to disable.
    mappings = {
      -- Basic mappings (better 'jk', save with Ctrl+S, ...)
      basic = false,

      -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
      -- Supply empty string to not create these mappings.
      option_toggle_prefix = [[\]],

      -- Window navigation with <C-hjkl>, resize with <C-arrow>
      windows = false,

      -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
      move_with_alt = false,
    },

    -- Autocommands. Set to `false` to disable
    autocommands = {
      -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
      basic = false,

      -- Set 'relativenumber' only in linewise and blockwise Visual mode
      relnum_in_visual_mode = false,
    },

    -- Whether to disable showing non-error feedback
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.basics").setup(opts)
end

return M
