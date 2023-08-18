return {
  "jokajak/keyseer.nvim",
  cmd = { "KeySeer" },
  opts = function()
    return {
      -- Prints useful logs about what event are triggered, and reasons actions are executed.
      debug = false,
      -- Initial neovim mode to display keybindings
      initial_mode = "n",

      -- Boolean to include built in keymaps in display
      include_builtin_keymaps = true,
      -- Boolean to include global keymaps in display
      include_global_keymaps = true,
      -- Boolean to include buffer keymaps in display
      include_buffer_keymaps = true,
      -- Boolean to include modified keys (e.g. <C-x> or <A-y> or C) in display
      include_modified_keypresses = false,
      -- Boolean to ignore whichkey keymaps
      ignore_whichkey_conflicts = true,

      -- Configuration for ui:
      -- - `border` defines border (as in `nvim_open_win()`).
      ui = {
        border = "double", -- none, single, double, shadow
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        size = {
          width = 65,
          height = 10,
        },
        icons = {
          keyseer = "",
        },
        show_header = true, -- boolean if the header should be shown
      },

      -- Keyboard options
      keyboard = {
        -- Layout of the keycaps
        layout = "qwerty",
        keycap_padding = { 0, 1, 0, 1 }, -- padding around keycap labels [top, right, bottom, left]
        -- How much padding to highlight around each keycap
        highlight_padding = { 0, 0, 0, 0 },
        -- override the label used to display some keys.
        key_labels = {
          ["Up"] = "↑",
          ["Down"] = "↓",
          ["Left"] = "←",
          ["Right"] = "→",
          ["<F1>"] = "F1",
          ["<F2>"] = "F2",
          ["<F3>"] = "F3",
          ["<F4>"] = "F4",
          ["<F5>"] = "F5",
          ["<F6>"] = "F6",
          ["<F7>"] = "F7",
          ["<F8>"] = "F8",
          ["<F9>"] = "F9",
          ["<F10>"] = "F10",

          -- For example:
          -- ["<space>"] = "SPC",
          -- ["<cr>"] = "RET",
          -- ["<tab>"] = "TAB",
        },
      },
    }
  end,
  config = function(_, opts)
    require("keyseer").setup(opts)
  end,
}
