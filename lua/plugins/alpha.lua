return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    local header = {
      type = "text",
      val = {
        [[                                  __                   ]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___       ]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\     ]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \    ]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\   ]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/   ]],
        [[                                                       ]],
      },
      opts = {
        position = "center",
        hl = "Type",
      },
    }

    local buttons = {
      type = "group",
      val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        -- dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("o", " " .. " Oil", ":Oil <CR>"),
        -- dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Grep text", ":Telescope live_grep <CR>"),
        dashboard.button("h", " " .. " Check Health", ":checkhealth <CR>"),
        dashboard.button("c", " " .. " Config", ":cd $HOME/.config/nvim | e $MYVIMRC <CR>"),
        dashboard.button("m", "󰢛 " .. " Mason", ":Mason <CR>"),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy <CR>"),
        dashboard.button("q", " " .. " Quit", ":qa <CR>"),
      },
      opts = {
        spacing = 1,
        hl_shortcut = "Keyword",
      },
    }

    local footer = {
      type = "text",
      val = "",
      opts = {
        position = "center",
        hl = "Number",
      },
    }

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    return {
      autostart = true,
      layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        buttons,
        { type = "padding", val = 2 },
        footer,
      },
    }
  end,
  config = function(_, opts)
    require("alpha").setup(opts)
  end,
}
