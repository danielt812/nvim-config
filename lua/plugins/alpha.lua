local M = { "goolord/alpha-nvim" }

M.enabled = true

M.event = { "VimEnter" }

M.opts = function()
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
      dashboard.button("f", " " .. " Find file", ":FzfLua files <CR>"),
      dashboard.button("o", " " .. " Oil", ":Oil <CR>"),
      dashboard.button("g", " " .. " Live Grep", ":FzfLua live_grep <CR>"),
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
      vim.cmd("AlphaRedraw")
    end,
  })

  local win_height = vim.api.nvim_win_get_height(0)

  local header_pad = math.ceil(win_height / 5)
  local button_pad = math.ceil(win_height / 3)
  local footer_pad = math.ceil(win_height / 3)

  return {
    autostart = true,
    layout = {
      { type = "padding", val = header_pad },
      header,
      { type = "padding", val = 4 },
      buttons,
      { type = "padding", val = 4 },
      footer,
    },
  }
end

M.config = function(_, opts)
  require("alpha").setup(opts)
end

return M
