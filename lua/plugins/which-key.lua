return {
  {
    "folke/which-key.nvim",
    event = { "BufReadPost" },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 0
    end,
    opts = function()
      return {
        plugins = {
          marks = true, -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          -- the presets plugin, adds help for a bunch of default keybindings in Neovim
          -- No actual key bindings are created
          spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
          },
          presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
          },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        key_labels = {
          -- override the label used to display some keys. It doesn't effect WK in any other way.
          -- For example:
          -- ["<space>"] = "SPC",
          -- ["<CR>"] = "RET",
          -- ["<tab>"] = "TAB",
        },
        motions = {
          count = true,
        },
        icons = {
          breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
          separator = "➜", -- symbol used between a key and it's label
          group = "+", -- symbol prepended to a group
        },
        popup_mappings = {
          scroll_down = "<c-d>", -- binding to scroll down inside the popup
          scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },
        window = {
          border = "none", -- none, single, double, shadow
          position = "bottom", -- bottom, top
          margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
          padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
          zindex = 1000, -- positive value to position WhichKey above other floating windows.
        },
        layout = {
          height = { min = 4, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 3, -- spacing between columns
          align = "left", -- align columns left, center or right
        },
        ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua ", "<Plug>" }, -- hide mapping boilerplate
        show_help = true, -- show a help message in the command line for using WhichKey
        show_keys = true, -- show the currently pressed key and its label as a message in the command line
        triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
        -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        triggers_nowait = {
          -- marks
          "`",
          "'",
          "g`",
          "g'",
          -- registers
          '"',
          "<c-r>",
          -- spelling
          "z=",
        },
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for keymaps that start with a native binding
          i = { "j", "k" },
          v = { "j", "k" },
        },
        -- disable the WhichKey popup for certain buf types and file types.
        -- Disabled by default for Telescope
        disable = {
          buftypes = {},
          filetypes = { "alpha", "lazy", "mason" },
        },
        m_opts = {
          mode = { "n", "v" }, -- NORMAL mode
          -- prefix: use "<leader>f" for example for mapping everything related to finding files
          -- the prefix is prepended to every mapping part of `mappings`
          prefix = "<leader>",
          buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
          silent = true, -- use `silent` when creating keymaps
          noremap = true, -- use `noremap` when creating keymaps
          nowait = false, -- use `nowait` when creating keymaps
          -- expr = false,   -- use `expr` when creating keymaps
        },
        mappings = {
          -- ["."] = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format 󰘞 " },
          -- [";"] = { "<cmd>Alpha<CR>", "Dashboard 󱒉 " },
          -- ["c"] = { "<cmd>BufferClose<CR>", "Close Buffer   " },
          -- ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer 󰙅 " },
          -- ["h"] = { "<cmd>nohlsearch<CR>", "Clear Highlight 󰹊 " },
          -- ["/"] = { name = "+Comment  " },
          ["b"] = {
            name = "+Buffer  ",
            ["g"] = { name = "+GoTo  " },
            ["c"] = { name = "+Close  " },
            ["s"] = { name = "+Sort 󰒺 " },
          },
          ["d"] = {
            name = "+Debug  ",
            ["a"] = { name = "+Adapters  " },
            ["s"] = { name = "+Step  " },
            ["r"] = { name = "+Repl  " },
          },
          ["f"] = {
            name = "+Telescope  ",
          },
          ["g"] = {
            name = "+Git  ",
            ["c"] = { name = "+Conflict  " },
            -- ["s"] = { name = "+Signs  " },
            ["t"] = { name = "+Toggle 󰨚  " },
          },
          ["l"] = {
            name = "+LSP  ",
            ["a"] = { name = "+Actions 󱐌 " },
            ["d"] = { name = "+Diagnostics  " },
            ["i"] = { name = "+Info  " },
            ["f"] = { name = "+Find   " },
          },
          ["r"] = {
            name = "+Replace 󰛔 ",
            ["w"] = { name = "+Word  " },
            ["s"] = { name = "+Search 󱩾 " },
          },
          ["t"] = {
            name = "+Toggle 󰨚  ",
          },
          ["w"] = {
            name = "+Window  ",
            ["s"] = "+Split 󰃻 ",
          },
        },
      }
    end,
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register(opts.mappings, opts.m_opts)
    end,
  },
}
