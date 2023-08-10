return {
  "numToStr/Comment.nvim",
  event = { "VeryLazy" },
  opts = function()
    return {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gcc",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gc",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      ---Enable keybindings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    }
  end,
  config = function(_, opts)
    require("Comment").setup(opts)

    local map = function(mode, lhs, rhs, key_opts)
      key_opts = key_opts or {}
      key_opts.silent = true
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    map("n", "<leader>/l", "<Plug>(comment_toggle_linewise_current)", { desc = "Linewise" })
    map("n", "<leader>/b", "<Plug>(comment_toggle_blockwise_current)", { desc = "Blockwise" })
    map("x", "<leader>/l", "<Plug>(comment_toggle_linewise_visual)", { desc = "Linewise" })
    map("x", "<leader>/b", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Blockwise" })
  end,
}
