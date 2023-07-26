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
        replace = "DiffDelete"
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
              desc = "ignore case"
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]"
            },
          }
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
              desc = "ignore case"
            },
          }
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case" }
        },
        replace = {
          cmd = "sed"
        }
      },
      is_open_target_win = true, --open file on opener window
      is_insert_mode = true      -- start open panel on is_insert_mode
    }
  end,
  config = function(_, opts)
    require("spectre").setup(opts)
  end
}
