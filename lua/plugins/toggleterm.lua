return {
  "akinsho/toggleterm.nvim",
  cmd = {
    "ToggleTerm",
    "TermExec",
    "ToggleTermToggleAll",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
  },
  opts = function()
    return {
      size = 80,
      open_mapping = [[<c-\>]],
      shade_filetypes = {},
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      insert_mappings = true,
      -- terminal_mappings = true,
      start_in_insert = true,
      persist_size = false,
      persist_mode = true,
      close_on_exit = true,
      direction = "vertical",
      shell = nil,
      autochdir = false,
      auto_scroll = true,
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return string.format("%d:%s", term.id, term:_display_name())
        end,
      },
      float_opts = {
        winblend = 0,
      },
    }
  end,
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local function map(lhs, rhs)
      local key_opts = {}
      key_opts.noremap = true
      vim.api.nvim_buf_set_keymap(0, "t", lhs, rhs, key_opts)
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      desc = "Set terminal keymaps",
      callback = function()
        map("<esc>", [[<C-\><C-n>]])
        map("<C-h>", [[<C-\><C-n><C-W>h]])
        map("<C-j>", [[<C-\><C-n><C-W>j]])
        map("<C-k>", [[<C-\><C-n><C-W>k]])
        map("<C-l>", [[<C-\><C-n><C-W>l]])
      end,
    })
  end,
}
