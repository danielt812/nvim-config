local M = { "lewis6991/gitsigns.nvim" }

M.enabled = true

M.event = { "BufReadPost" }

M.cmd = { "Gitsigns" }

M.keys = {
  { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff  " },
  { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Blame Line  " },
  { "<leader>gtd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Deleted 󱂦 " },
  { "<leader>gth", "<cmd>Gitsigns toggle_numhl<cr>", desc = "Num Highlight 󰎠 " },
  { "<leader>gtl", "<cmd>Gitsigns toggle_linehl<cr>", desc = "Line Highlight 󰸱 " },
  { "<leader>gts", "<cmd>Gitsigns toggle_signs<cr>", desc = "Signs  " },
  { "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Word Diff  " },
  { "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
  { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Unstage" },
  { "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset" },
  { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview" },
}

M.opts = function()
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
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 0,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%R>  <summary>",
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
    on_attach = function()
      -- vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00" })
      -- vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#0000ff" })
      -- vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000" })
    end,
  }
end

M.config = function(_, opts)
  require("gitsigns").setup(opts)
end

return M

