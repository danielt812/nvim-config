local M = { "ibhagwan/fzf-lua" }

M.enabled = false

M.cmd = { "FzfLua", "Fzf" }

M.dependencies = {
  "echasnovski/mini.icons",
}

M.keys = {
  { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Files  " },
  { "<leader>fc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme  " },
  { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Livegrep  " },
  { "<leader>fh", "<cmd>FzfLua highlights<cr>", desc = "Highlights 󰸱 " },
  { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps  " },
}

M.opts = function()
  local actions = require("fzf-lua").actions

  local colorscheme_ignore_patterns = {
    "^default$",
    "^delek$",
    "^desert$",
    "^elflord$",
    "^evening$",
    "^habamax$",
    "^industry$",
    "^koehler$",
    "^lunaperche$",
    "^morning$",
    "^murphy$",
    "^pablo$",
    "^peachpuff$",
    "^quiet$",
    "^randomhue$",
    "^retrobox$",
    "^ron$",
    "^shine$",
    "^slate$",
    "^sorbet$",
    "^torte$",
    "^unokai$",
    "^vim$",
    "^wildcharm$",
    "^zaibatsu$",
    "^zellner$",
    "blue$",
    "^mini",
  }
  return {
    "telescope",
    winopts = {
      preview = {
        hidden = "nohidden",
        vertical = "up:50%",
        horizontal = "right:50%",
        layout = "flex", -- horizontal, vertical, flex
        flip_columns = 120,
        delay = 10,
        winopts = { number = false },
      },
    },
    files = {
      cwd_prompt = false,
      fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude archive]],
      winopts = { height = 1, width = 1 },
      actions = {
        ["ctrl-h"] = { actions.toggle_hidden },
      },
    },
    colorschemes = {
      winopts = { height = 0.55, width = 0.30 },
      ignore_patterns = colorscheme_ignore_patterns,
    },
    grep = {
      winopts = { height = 1, width = 1 },
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
    },
    live_grep = {
      winopts = { height = 1, width = 1 },
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
    },
    oldfiles = {
      winopts = { height = 1, width = 1 },
    },
  }
end

M.config = function(_, opts)
  require("fzf-lua").setup(opts)
end

return M
