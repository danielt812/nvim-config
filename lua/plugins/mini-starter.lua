local M = { "echasnovski/mini.starter" }

M.enabled = true

M.event = { "VimEnter" }

M.opts = function()
  local starter = require("mini.starter")
  return {
    evaluate_single = true,
    header = table.concat({
      [[                                  __                   ]],
      [[     ___     ___    ___   __  __ /\_\    ___ ___       ]],
      [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\     ]],
      [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \    ]],
      [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\   ]],
      [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/   ]],
      [[                                                       ]],
    }, "\n"),
    items = {
      starter.sections.pick(),
      starter.sections.recent_files(5, true, false),
      starter.sections.sessions(5, true),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.indexing("all", { "Builtin actions", "Pick" }),
      starter.gen_hook.aligning("center", "center"),
    },
    footer = "",
  }
end

M.config = function(_, opts)
  require("mini.starter").setup(opts)
end

return M
