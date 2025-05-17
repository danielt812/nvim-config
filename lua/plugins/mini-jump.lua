local M = { "echasnovski/mini.jump" }

M.enabled = false

-- M.keys = { "f", "F", "t", "T" }

M.event = { "VeryLazy" }

M.opts = function()
  return {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      forward = "f",
      backward = "F",
      forward_till = "t",
      backward_till = "T",
      repeat_jump = ";",
    },

    -- Delay values (in ms) for different functionalities. Set any of them to
    -- a very big number (like 10^7) to virtually disable.
    delay = {
      -- Delay between jump and highlighting all possible jumps
      highlight = 0,

      -- Delay between jump and automatic stop if idle (no jump is done)
      idle_stop = 10000000,
    },

    -- Whether to disable showing non-error feedback
    -- This also affects (purely informational) helper messages shown after
    -- idle time if user input is required.
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.jump").setup(opts)
end

return M
