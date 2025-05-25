local M = { "echasnovski/mini.starter" }

M.enabled = true

M.keys = {
  { "<leader>e;", "<cmd>lua MiniStarter.open()<cr>", desc = "Starter" },
}

M.event = { "VimEnter" }

M.opts = function()
  local starter = require("mini.starter")

  local isometric = table.concat({
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }, "\n")

  local ogre = table.concat({
    [[     __                _           ]],
    [[  /\ \ \___  _____   _(_)_ __ ___  ]],
    [[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
    [[/ /\  /  __/ (_) \ V /| | | | | | |]],
    [[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
  }, "\n")

  local slant = table.concat({
    [[    _   __                _         ]],
    [[   / | / /__  ____ _   __(_)___ ___ ]],
    [[  /  |/ / _ \/ __ \ | / / / __ `__ \]],
    [[ / /|  /  __/ /_/ / |/ / / / / / / /]],
    [[/_/ |_/\___/\____/|___/_/_/ /_/ /_/ ]],
  }, "\n")

  math.randomseed(os.time())
  local headers = { isometric, ogre, slant }
  local header = headers[math.random(#headers)]

  return {
    evaluate_single = true,
    header = slant,
    items = {
      -- stylua: ignore start
      { name = "Files",         action = "Pick files",       section = "Actions" },
      { name = "Grep live",     action = "Pick grep_live",   section = "Actions" },
      { name = "Visited files", action = "Pick visit_paths", section = "Actions" },
      { name = "Help",          action = "Pick help",        section = "Actions" },
      { name = "Mason",         action = "Mason",            section = "Actions" },
      { name = "Lazy",          action = "Lazy",             section = "Actions" },
      { name = "Quit",          action = "qa!",              section = "Actions" },
      -- stylua: ignore end
      -- starter.sections.pick(),
      starter.sections.recent_files(5, true, false),
      starter.sections.sessions(5, true),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing("all", { "Builtin actions", "Pick", "Actions" }),
      starter.gen_hook.aligning("center", "center"),
    },
    footer = "",
  }
end

return M
