local M = { "gbprod/yanky.nvim" }

M.enabled = true

M.dependencies = { "nvim-telescope/telescope.nvim" }

M.event = { "BufRead" }

M.opts = function()
  local actions = require("telescope.actions")

  return {
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
    },
    picker = {
      select = {
        action = nil, -- nil to use default put action
      },
      telescope = {
        use_default_mappings = true, -- if default mappings should be used
        mappings = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        }, -- nil to use default mappings or no mappings (see `use_default_mappings`)
      },
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = false,
      on_yank = true,
      timer = 200,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  }
end

M.config = function(_, opts)
  require("yanky").setup(opts)
  require("telescope").load_extension("yank_history")
end

return M
