local M = { "echasnovski/mini.starter" }

M.enabled = true

M.keys = {
  { "<leader>e;", "<cmd>lua MiniStarter.open()<cr>", desc = "Starter" },
}

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
      -- stylua: ignore start
      { name = "Files",             action = "Pick files",                         section = "Actions" },
      { name = "Grep live",         action = "Pick grep_live",                     section = "Actions" },
      { name = "Oil",               action = "Oil",                     section = "Actions" },
      -- { name = "Search/Replace", action = "GrugFar",                            section = "Actions" },
      { name = "Health",            action = "checkhealth",                        section = "Actions" },
      { name = "Config",            action = "cd $HOME/.config/nvim | e $MYVIMRC", section = "Actions" },
      { name = "Visited files",     action = "Pick visit_paths",                   section = "Actions" },
      { name = "Mason",             action = "Mason",                              section = "Actions" },
      { name = "Lazy",              action = "Lazy",                               section = "Actions" },
      { name = "Quit",              action = "qa!",                                section = "Actions" },
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

M.config = function(_, opts)
  require("mini.starter").setup(opts)

  local ministarter_settings_group = vim.api.nvim_create_augroup("ministarter_settings_group", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = ministarter_settings_group,
    pattern = { "MiniStarterOpened" },
    desc = "Hide tabline when opening MiniStarter",
    callback = function()
      vim.opt_local.showtabline = 0
      vim.opt_local.laststatus = 0
      vim.opt_local.winbar = ""
    end,
  })
end

return M
