local starter = require("mini.starter")

local header = table.concat({
  [[                          _         ]],
  [[   ____  ___  ____ _   __(_)___ ___ ]],
  [[  / __ \/ _ \/ __ \ | / / / __ `__ \]],
  [[ / / / /  __/ /_/ / |/ / / / / / / /]],
  [[/_/ /_/\___/\____/|___/_/_/ /_/ /_/ ]],
}, "\n")

local v = vim.version()
local nvim_version = string.format("Neovim v%d.%d.%d", v.major, v.minor, v.patch)

starter.setup({
  evaluate_single = true,
  header = header,
  items = {
      -- stylua: ignore start
      { name = "Files",   action  = "Pick files",       section = "Actions" },
      { name = "Grep",    action  = "Pick grep_live",   section = "Actions" },
      { name = "Oil",     action  = "Oil",             section = "Actions" },
      { name = "Mason",   action  = "Mason",            section = "Actions" },
      { name = "Visited", action  = "Pick visit_paths", section = "Actions" },
      { name = "Quit",    action  = "qa!",              section = "Actions" },
    --stylua: ignore end
    starter.sections.recent_files(5, true, false),
    starter.sections.sessions(5, true),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.indexing("all", { "Builtin actions", "Pick", "Actions" }),
    starter.gen_hook.aligning("center", "center"),
  },
  footer = nvim_version,
})
