return {
  "nvim-telescope/telescope.nvim",
  event = { "VeryLazy" },
  cmd = { "Telescope" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", ".DS_Store", "node_modules", ".xlsx", ".png", "CHANGELOG.md" },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },
        },
      },
      pickers = {
        live_grep = {
          --@usage don't include the filename in the search results
          only_sort_text = true,
          hidden = true,
        },
        grep_string = {
          only_sort_text = true,
        },
        git_files = {
          hidden = true,
          show_untracked = true,
        },
        colorscheme = {
          enable_preview = true,
        },
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)

    local map = function(mode, lhs, rhs, key_opts)
      lhs = "<leader>" .. lhs
      rhs = "<cmd>Telescope " .. rhs .. "<CR>"
      key_opts = key_opts or {}
      key_opts.silent = true
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    -- +Find
    map("n", "fb", "git_branches", { desc = "Checkout Branch " })
    map("n", "fc", "colorscheme", { desc = "Colorscheme " })
    map("n", "fd", "commands", { desc = "Commands " })
    map("n", "ff", "find_files", { desc = "File 󰱽" })
    map("n", "fg", "live_grep", { desc = "Grep " })
    map("n", "fh", "help_tags", { desc = "Help 󰘥" })
    map("n", "fH", "highlights", { desc = "Highlight Groups 󰸱" })
    map("n", "fk", "keymaps", { desc = "Keymaps " })
    map("n", "fl", "resume", { desc = "Resume Last Search " })
    map("n", "fm", "man_pages", { desc = "Man Pages 󱗖" })
    map("n", "fr", "oldfiles", { desc = "Recent File " })
    map("n", "fR", "registers", { desc = "Registers " })
    map("n", "fs", "spell_suggest", { desc = "Spelling Suggestions 󰓆" })
    map("n", "ft", "grep_string", { desc = "Text " })

    -- +LSP -> +Find
    map("n", "lfb", "diagnostics bufnr=0", { desc = "Buffer Diagnostics  " })
    map("n", "lfd", "diagnostics", { desc = "Diagnostics  " })
    map("n", "lfe", "lsp_definitions", { desc = "Definitions  " })
    map("n", "lfq", "quickfix", { desc = "Quickfix   " })
    map("n", "lfr", "lsp_references", { desc = "References  " })
    map("n", "lfu", "lsp_document_symbols", { desc = "Document Symbols 󱪚 " })
    map("n", "lfw", "lsp_dynamic_workspace_symbols", { desc = "Workspace Symbols 󱈹 " })

    -- +Buffer -> +Find
    map("n", "bgf", "Telescope buffers previewer=true", { desc = "Find  " })
  end,
}
