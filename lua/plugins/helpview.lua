local M = { "OXY2DEV/helpview.nvim" }

M.enabled = true

M.event = { "VeryLazy" }

M.ft = { "help" }

M.opts = function()
  return {
    vimdoc = {
      headings = {
        heading_1 = { sign = " H1 " },
        heading_2 = { sign = " H2 " },
        heading_3 = { sign = " H3 " },
        heading_4 = { sign = " H4 " },
      },
    },
  }
end

return M
