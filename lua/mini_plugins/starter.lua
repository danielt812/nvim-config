local starter = require("mini.starter")
local tips = require("lib.tips")

local header = table.concat({
  [[                          _         ]],
  [[   ____  ___  ____ _   __(_)___ ___ ]],
  [[  / __ \/ _ \/ __ \ | / / / __ `__ \]],
  [[ / / / /  __/ /_/ / |/ / / / / / / /]],
  [[/_/ /_/\___/\____/|___/_/_/ /_/ /_/ ]],
}, "\n")

math.randomseed(os.time())
local t = tips[math.random(#tips)]
local parts = {
  "Tip\n",
  ":" .. t.cmd,
  "→ " .. t.desc,
}
if t.example then table.insert(parts, t.example) end
local tip = table.concat(parts, "\n")

starter.setup({
  evaluate_single = true,
  header = header,
  items = {
    -- stylua: ignore start
    { name = "Files",    action  = "Pick files",           section = "Actions" },
    { name = "Grep",     action  = "Pick grep_live",       section = "Actions" },
    { name = "Explorer", action  = "lua MiniFiles.open()", section = "Actions" },
    { name = "Help",     action  = "Pick help",            section = "Actions" },
    { name = "Mason",    action  = "Mason",                section = "Actions" },
    { name = "Visited",  action  = "Pick visit_paths",     section = "Actions" },
    { name = "Quit",     action  = "qa!",                  section = "Actions" },
    --stylua: ignore end
    starter.sections.recent_files(5, true, false),
    starter.sections.sessions(5, true),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.indexing("all", { "Builtin actions", "Pick", "Actions" }),
    starter.gen_hook.aligning("center", "center"),
  },
  footer = tip,
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function open() starter.open() end

vim.keymap.set("n", "<leader>e;", open, { desc = "Starter" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_starter_tabline", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MiniStarterOpened",
  desc = "Hide tabline on starter page",
  callback = function()
    vim.o.showtabline = 0
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  desc = "Restore tabline on leaving starter",
  callback = function()
    if vim.bo.filetype == "ministarter" then vim.o.showtabline = 2 end
  end,
})

