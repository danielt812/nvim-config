local M = { "folke/snacks.nvim" }

M.enabled = false

M.event = { "VeryLazy" }

M.opts = function()
  return {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    dim = { enabled = true },
    explorer = { enabled = true },
    lazygit = { enabled = true },
    indent = { enabled = false },
    input = { enabled = false },
    picker = {
      enabled = false,
      actions = {
        confirm_and_close = function(picker)
          picker:action("confirm")
          picker:action("close")
        end,
        confirm_nofocus = function(picker)
          picker:action("confirm")
          picker:focus()
        end,
      },
      sources = {
        explorer = {
          auto_close = true,
          layout = {
            preset = "sidebar",
            preview = "main",
          },
          win = {
            list = {
              keys = {
                ["L"] = "confirm_and_close",
                ["l"] = "confirm_nofocus",
              },
            },
          },
        },
      },
    },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    zen = { enabled = true },
  }
end

M.config = function(_, opts)
  require("snacks").setup(opts)
end

return M
