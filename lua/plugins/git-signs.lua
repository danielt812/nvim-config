return {
  "lewis6991/gitsigns.nvim",
  event = { "BufEnter", "BufRead" },
  cmd = "Gitsigns",
  opts = function()
    return {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      -- <author_time:%a %b %d %Y %I:%M:%S %p>
      current_line_blame_formatter = "    <author>, <author_time:%a %b %d %Y %I:%M:%S %p> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
    }
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)

    local map = function(mode, lhs, rhs, key_opts)
      lhs = "<leader>gs" .. lhs
      rhs = "<cmd>Gitsigns " .. rhs .. "<CR>"
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    -- +Signs
    map("n", "b", "toggle_current_line_blame", { desc = "Toggle Blame Line 󰋇 " })
    map("n", "d", "toggle_deleted", { desc = "Toggle Deleted 󱂦 " })
    map("n", "h", "toggle_linehl", { desc = "Toggle Line Highlight 󰸱 " })
    map("n", "n", "toggle_numhl", { desc = "Toggle Num Highlight 󰎠 " })
    map("n", "s", "toggle_signs", { desc = "Toggle Signs  " })
    map("n", "w", "toggle_word_diff", { desc = "Toggle Word Diff  " })
  end,
}