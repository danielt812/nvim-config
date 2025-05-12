local M = { "echasnovski/mini.align" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      start = "ga",
      start_with_preview = "gA",
    },

    -- Modifiers changing alignment steps and/or options
    -- Default options controlling alignment process
    options = {
      split_pattern = "",
      justify_side = "left",
      merge_delimiter = "",
    },

    -- Default steps performing alignment (if `nil`, default is used)
    steps = {
      pre_split = {},
      split = nil,
      pre_justify = {},
      justify = nil,
      pre_merge = {},
      merge = nil,
    },

    -- Whether to disable showing non-error feedback
    -- This also affects (purely informational) helper messages shown after
    -- idle time if user input is required.
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.align").setup(opts)
end

return M
