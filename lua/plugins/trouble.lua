local M = { "folke/trouble.nvim" }

M.enabled = true

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.cmd = {
  "Trouble",
}

M.keys = {
  {
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Diagnostics",
  },
  {
    "<leader>xX",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "Buffer Diagnostics",
  },
  {
    "<leader>xs",
    "<cmd>Trouble symbols toggle focus=false<cr>",
    desc = "Symbols",
  },
  {
    "<leader>xl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    desc = "LSP Definitions",
  },
  {
    "<leader>xL",
    "<cmd>Trouble loclist toggle<cr>",
    desc = "Location List",
  },
  {
    "<leader>xQ",
    "<cmd>Trouble qflist toggle<cr>",
    desc = "Quickfix List",
  },
}

M.opts = function()
  return {
    auto_close = false, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = true, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = false, -- auto jump to the item when there's only one
    focus = false, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = true, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = true, -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results
    icons = {
      kinds = require("icons.kind"),
    },
  }
end

M.config = function(_, opts)
  require("trouble").setup(opts)
end

return M
