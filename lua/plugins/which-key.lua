return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
          [";"] = { "<cmd>Alpha<CR>", "Dashboard 󱒉 " },
          -- ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment  " },
          -- ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer  " },
          -- ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer 󰙅 " },
          -- ["h"] = { "<cmd>nohlsearch<CR>", "Clear Highlight 󰹊 " },
          -- ["j"] = { "<cmd>TSJToggle<CR>", "Join/Split 󰃻 " },
          -- ["q"] = { "<cmd>confirm q<CR>", "Quit  " },
          -- ["r"] = { "<cmd>Spectre<CR>", "Spectre 󱙝 " },
          -- ["s"] = { "<cmd>w<CR>", "Save  " },
          b = {
            name = "+Buffer  ",
            g = {
              name = "+GoTo",
              ["f"] = { "<cmd>Telescope buffers previewer=false<CR>", "Find  " },
              ["n"] = { "<cmd>BufferLineCycleNext<CR>", "Next 󰮱 " },
              ["p"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous 󰮳 " },
            },
            c = {
              name = "+Close",
              ["c"] = { "<cmd>BufferKill<CR>", "Current  " },
              ["h"] = { "<cmd>BufferLineCloseLeft<CR>", "Left 󰳞 " },
              ["l"] = { "<cmd>BufferLineCloseRight<CR>", "Right 󰳠 " },
              ["o"] = { "<cmd>BufferLineCloseOthers<CR>", "Others  " },
              ["p"] = { "<cmd>BufferLinePickClose<CR>", "Pick  " },
            },
            s = {
              name = "+Sort",
              ["d"] = { "<cmd>BufferLineSortByDirectory<CR>", "Sort by directory  " },
              ["l"] = { "<cmd>BufferLineSortByExtension<CR>", "Sort by language" },
            },
          },
          e = {
            name = "+Editor 󰘙 ",
            c = {
              name = "+Comment  ",
              ["l"] = { "<Plug>(comment_toggle_linewise_current)", "Linewise  " },
              ["b"] = { "<Plug>(comment_toggle_blockwise_current)", "Blockwise  " },
            },
            e = {
              name = "Explorer 󰙅 ",
              ["c"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse  " },
              ["e"] = { "<cmd>NvimTreeToggle<CR>", "Toggle 󰨚 " },
              ["f"] = { "<cmd>NvimTreeFindFile<CR>", "Find File  " },
            },
            ["f"] = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format File 󰘞 " },
            ["h"] = { "<cmd>nohlsearch<CR>", "Clear Highlight 󰹊 " },
            -- ["j"] = { "<cmd>TSJToggle<CR>", "Join/Split 󰃻 " },
            ["q"] = { "<cmd>confirm q<CR>", "Quit  " },
            ["r"] = { "<cmd>Spectre<CR>", "Spectre 󱙝 " },
            ["s"] = { "<cmd>w<CR>", "Save  " },
            ["v"] = { "<cmd>noautocmd w<CR>", "Save without formatting  " },
            ["t"] = { "<cmd>Twilight<CR>", "Toggle Twilight 󰖚 " },
          },
          f = {
            name = "+Telescope   ",
            ["b"] = { "<cmd>Telescope git_branches<CR>", "Checkout branch  " },
            ["c"] = { "<cmd>Telescope colorscheme<CR>", "Colorscheme   " },
            ["d"] = { "<cmd>Telescope commands<CR>", "Commands   " },
            ["f"] = { "<cmd>Telescope find_files<CR>", "Find File   " },
            ["g"] = { "<cmd>Telescope live_grep<CR>", "Grep Text   " },
            ["h"] = { "<cmd>Telescope help_tags<CR>", "Find Help 󰘥  " },
            ["H"] = { "<cmd>Telescope highlights<CR>", "Find highlight groups 󰸱  " },
            ["k"] = { "<cmd>Telescope keymaps<CR>", "Keymaps   " },
            ["l"] = { "<cmd>Telescope resume<CR>", "Resume last search  " },
            ["m"] = { "<cmd>Telescope man_pages<CR>", "Man Pages 󱗖  " },
            ["r"] = { "<cmd>Telescope oldfiles<CR>", "Open Recent File   " },
            ["R"] = { "<cmd>Telescope registers<CR>", "Registers" },
          },
          g = {
            name = "+Git  ",
            ["b"] = { "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle Blame Line 󰋇 " },
            ["c"] = { "<cmd>GitBlameCopySHA", "Copy SHA  " },
            ["d"] = { "<cmd>Gitsigns toggle_deleted<CR>", "Toggle Deleted 󱂦 " },
            ["l"] = { "<cmd>Gitsigns toggle_linehl <CR>", "Toggle Line Highlight 󰸱 " },
            ["n"] = { "<cmd>Gitsigns toggle_numhl<CR>", "Toggle Num Highlight 󰎠 " },
            ["o"] = { "<cmd>GitBlameOpenCommitURL<CR>", "Open SHA  " },
            ["s"] = { "<cmd>Gitsigns toggle_signs<CR>", "Toggle Signs  " },
            ["w"] = { "<cmd>Gitsigns toggle_word_diff<CR>", "Toggle Word Diff  " },
          },
          l = {
            name = "+LSP  ",
            d = {
              name = "+Diagnostics  ",
              ["b"] = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<CR>", "Buffer Diagnostics" },
              ["j"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic 󰮱 " },
              ["k"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev Diagnostic 󰮳 " },
              ["w"] = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
              ["t"] = { "<cmd>TroubleToggle<CR>", "Trouble Toggle  " },
            },
            i = {
              name = "+Info  ",
              ["l"] = { "<cmd>LspInfo<CR>", "LSP Info  " },
              ["m"] = { "<cmd>Mason<CR>", "Mason Info 󰢛 " },
              ["t"] = { "<cmd>TSModuleInfo<CR>", "Treesitter Info 󱖫 " },
              ["n"] = { "<cmd>NullLsInfo<CR>", "Null-LS Info " },
            },
            f = {
              name = "+Find  ",
              ["d"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
              ["w"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace Symbols" },
              ["q"] = { "<cmd>Telescope quickfix<CR>", "Quickfix" },
            },
            ["a"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
            -- ["f"] = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format File 󰘞 " },
            ["l"] = { "<cmd>lua vim.lsp.codelens.run()<CR>", "CodeLens Action" },
            ["r"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
          },
          p = {
            name = "+Plugin  ",
            ["c"] = { "<cmd>Lazy clean<CR>", "Clean 󰃢 " },
            ["d"] = { "<cmd>Lazy debug<CR>", "Debug  " },
            ["g"] = { "<cmd>Lazy log<CR>", "Log 󰯃 " },
            ["i"] = { "<cmd>Lazy install<CR>", "Install  " },
            ["l"] = { "<cmd>Lazy<CR>", "Lazy 󰒲 " },
            ["p"] = { "<cmd>Lazy profile<CR>", "Profile 󰙄 " },
            ["s"] = { "<cmd>Lazy sync<CR>", "Sync  " },
            ["t"] = { "<cmd>Lazy clear<CR>", "Status 󱖫 " },
            ["u"] = { "<cmd>Lazy update<CR>", "Update 󰚰 " },
          },
          s = {
            name = "+Surround 󰅪 ",
            ["a"] = { "<Plug>(nvim-surround-normal)a", "Around" },
            ["c"] = { "<Plug>(nvim-surround-change)", "Change" },
            ["d"] = { "<Plug>(nvim-surround-delete)", "Delete" },
            ["l"] = { "<Plug>(nvim-surround-normal-line)", "Line" },
          },
          w = {
            name = "+Window  ",
            -- ["-"] = { "<cmd>split<CR>", "Split Horizontal  " },
            -- ["|"] = { "<cmd>vsplit<CR>", "Split Vertical  " },
            ["c"] = { "<cmd>close<CR>", "Close Split  " },
            ["h"] = { "<cmd>split<CR>", "Split Horizontal  " },
            ["v"] = { "<cmd>vsplit<CR>", "Split Vertical  " },
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
