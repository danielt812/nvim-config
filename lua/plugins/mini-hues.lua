local M = { "echasnovski/mini.hues" }

M.enabled = false

M.event = "VimEnter"

M.opts = function()
  return {
    -- **Required** base colors as '#rrggbb' hex strings
    background = "#000000",
    foreground = "#c0c8cc",

    -- Number of hues used for non-base colors
    n_hues = 8,

    -- Saturation level. One of 'low', 'medium', 'high'.
    saturation = "medium",

    -- Accent color. One of: 'bg', 'fg', 'red', 'orange', 'yellow', 'green',
    -- 'cyan', 'azure', 'blue', 'purple'
    accent = "bg",

    -- Plugin integrations. Use `default = false` to disable all integrations.
    -- Also can be set per plugin (see |MiniHues.config|).
    plugins = { default = true },
  }
end

M.config = function(_, opts)
  require("mini.hues").setup(opts)
end

return M
