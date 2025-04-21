local M = { "echasnovski/mini.pick" }

M.enabled = false

M.event = { "VeryLazy" }

M.opts = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    window = {
      config = {
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.pick").setup(opts)
end

return M
