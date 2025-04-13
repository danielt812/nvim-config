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
      dashboard.button("n", " " .. " New file", ":enew"),
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

  -- Define your elements' height or assume a fixed height for them
  local header_height = 3 -- Adjust based on your actual header size
  local buttons_height = 5 -- Adjust based on your actual buttons size
  local footer_height = 2 -- Adjust based on your actual footer size

  -- Calculate the total height of all the fixed elements
  local total_content_height = header_height + buttons_height + footer_height

  -- Calculate the remaining height for padding
  local remaining_height = win_height - total_content_height

  -- Ensure there's enough space for padding, otherwise default to minimal padding
  local padding = math.max(0, math.floor(remaining_height / 7))

  return {
    autostart = true,
    layout = {
      { type = "padding", val = padding },
      header,
      { type = "padding", val = padding },
      buttons,
      { type = "padding", val = padding },
      footer,
    },
  }
end

M.config = function(_, opts)
  require("alpha").setup(opts)
end

return M
