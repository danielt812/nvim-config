return {
  "nvim-pack/nvim-spectre",
  cmd = { "Spectre" },
  opts = function()
    return {
      color_devicons = true,
      open_cmd = "noswapfile vnew",
      live_update = true, -- auto execute search again when you write to any file in vim
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete",
      },
      mapping = {
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "Toggle Item",
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
          desc = "Open File",
        },
        ["send_to_qf"] = {
          map = "<leader>rq",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "Quickfix 󰁨 ",
        },
        ["replace_cmd"] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = "Input Replace Command 󰛔 ",
        },
        ["show_option_menu"] = {
          map = "<leader>ro",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "Show Options 󰢻 ",
        },
        ["run_current_replace"] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
          desc = "Replace Current Line  ",
        },
        ["run_replace"] = {
          map = "<leader>rr",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "Replace All  ",
        },
        ["change_view_mode"] = {
          map = "<leader>rv",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "Change Result View Mode 󰹬 ",
        },
        ["change_replace_sed"] = {
          map = "<leader>rS",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "Use Sed To Replace 󱒐 ",
        },
        ["change_replace_oxi"] = {
          map = "<leader>rO",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "Use Oxi To Replace  ",
        },
        ["toggle_live_update"] = {
          map = "<leader>ru",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "Update When Vim Writes To File 󰚰 ",
        },
        ["toggle_ignore_case"] = {
          map = "<leader>ri",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "Toggle Ignore Case  ",
        },
        ["toggle_ignore_hidden"] = {
          map = "<leader>rh",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "Toggle Search Hidden  ",
        },
        ["resume_last_search"] = {
          map = "<leader>rl",
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = "Repeat Last Search 󰑖 ",
        },
        -- you can put your mapping here it only use normal mode
      },
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]",
            },
          },
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = nil,
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case" },
        },
        replace = {
          cmd = "sed",
        },
      },
      is_open_target_win = true, --open file on opener window
      is_insert_mode = false, -- start open panel on is_insert_mode
    }
  end,
  config = function(_, opts)
    require("spectre").setup(opts)
  end,
}
