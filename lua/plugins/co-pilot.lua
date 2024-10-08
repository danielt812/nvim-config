local M = { "zbirenbaum/copilot.lua" }

M.enabled = true

M.dependencies = { "zbirenbaum/copilot-cmp" }

M.cmd = { "Copilot" }

M.event = { "InsertEnter" }

M.opts = function()
  return {
    copilot = {
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<leader><CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      server_opts_overrides = {},
    },
    cmp = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      fix_pairs = true,
      clear_after_cursor = true,
    },
  }
end

M.config = function(_, opts)
  require("copilot").setup(opts.copilot)
  require("copilot_cmp").setup(opts.cmp)
end

return M

