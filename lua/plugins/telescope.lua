local M = { "nvim-telescope/telescope.nvim" }

M.enabled = true

M.dependencies = {
  "nvim-lua/plenary.nvim",
}

M.cmd = {
  "Telescope",
}

M.opts = function()
  local actions = require("telescope.actions")

  return {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      color_devicons = true,
      file_ignore_patterns = {
        "%.git/",
        "%.DS_Store",
        "node_modules",
        "%.xlsx",
        "%.png",
        "%.jpeg",
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["q"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
        },
      },
    },
    pickers = {
      live_grep = {
        hidden = "true",
      },
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        hidden = true,
      },
    },
  }
end

M.config = function(_, opts)
  require("telescope").setup(opts)
end

return M
