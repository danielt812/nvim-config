local M = { "echasnovski/mini.bufremove" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {
    -- Whether to set Vim's settings for buffers (allow hidden buffers)
    set_vim_settings = true,

    -- Whether to disable showing non-error feedback
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.bufremove").setup(opts)
end

return M
