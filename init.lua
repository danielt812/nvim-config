-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/nvim-mini/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local deps = require("mini.deps")

-- Set up 'mini.deps' (customize to your liking)
deps.setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = deps.add, deps.now, deps.later

--- Safely notifies an error message after a short delay to allow notify plugin to initialize.
--- @param msg string: The error message to display.
local function delayed_notify(msg)
  vim.schedule(function()
    vim.defer_fn(function() vim.notify(msg, vim.log.levels.ERROR) end, 100) -- delay in ms; adjust if needed
  end)
end

--- Loads a module from the `plugins` namespace with error handling.
--- @param plugin string: Name of the plugin module (without the "plugins." prefix).
local function plug(plugin)
  local ok, err = pcall(require, "plugins." .. plugin)
  if not ok then delayed_notify("Failed to load plugin module: plugins." .. plugin .. "\n" .. err) end
end

--- Loads a module from the `mini_plugins` namespace with error handling.
--- @param plugin string: Name of the plugin module (without the "mini_plugins." prefix).
local function mplug(plugin)
  local ok, err = pcall(require, "mini_plugins." .. plugin)
  if not ok then delayed_notify("Failed to load plugin module: mini_plugins." .. plugin .. "\n" .. err) end
end

--- Loads a configuration module from the `config` namespace with error handling.
--- @param config string: Name of the config module (without the "config." prefix).
local function conf(config)
  local ok, err = pcall(require, "config." .. config)
  if not ok then delayed_notify("Failed to load config file: config." .. config .. "\n" .. err) end
end

now(function()
  local built_ins = { "netrwPlugin", "netrw", "netrwSettings", "netrwFileHandlers", "tutor" }
  for _, plugin in ipairs(built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end

  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  local providers = { "perl", "node", "python3", "ruby" }
  for _, provider in ipairs(providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end

  conf("options")
  conf("keymaps")
  conf("autocmds")
  conf("lsp")
  conf("diagnostics")
  conf("marks")
  conf("quickfix")
  conf("terminal")
  conf("tmux")
  conf("folds")

  vim.g.colors_variant = "soft"
  vim.cmd("colorscheme everforest")

  -- Mini modules now ------------------------------------------------------------
  mplug("notify")
  mplug("starter")
  mplug("sessions")
  mplug("completion")
  mplug("snippets")
end)

-- Mini modules later ----------------------------------------------------------
later(function()
  mplug("ai")
  mplug("align")
  mplug("animate")
  mplug("basics")
  mplug("bufremove")
  mplug("clue")
  mplug("cmdline")
  mplug("colors")
  mplug("comment")
  mplug("cursorword")
  mplug("diff")
  mplug("extra")
  mplug("files")
  mplug("git")
  mplug("hipatterns")
  mplug("icons")
  mplug("indentscope")
  mplug("jump")
  mplug("jump2d")
  mplug("keymap")
  mplug("map")
  mplug("misc")
  mplug("move")
  mplug("operators")
  mplug("pairs")
  mplug("pick")
  mplug("splitjoin")
  mplug("statusline")
  mplug("surround")
  mplug("tabline")
  mplug("trailspace")
end)

-- Treesitter ------------------------------------------------------------------
now(function()
  -- Treesitter
  add({ source = "nvim-treesitter/nvim-treesitter" })
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })
  plug("tree-sitter")

  -- Rainbow delimeters
  add({ source = "HiPhish/rainbow-delimiters.nvim" })
  plug("rainbow-delimeters")

  -- Split/join
  add({ source = "Wansmer/treesj" })
  plug("treesj")

  -- Autotag
  add({ source = "windwp/nvim-ts-autotag" })
  plug("autotag")
end)

-- Filetype rendering ----------------------------------------------------------
now(function()
  add({ source = "OXY2DEV/markview.nvim" })
  add({ source = "OXY2DEV/helpview.nvim" })
end)

-- Debugging -------------------------------------------------------------------
later(function()
  add({ source = "mfussenegger/nvim-dap" })
  add({ source = "igorlfs/nvim-dap-view" })
  plug("dap")
end)

-- Executables -----------------------------------------------------------------
later(function()
  -- Manager
  add({ source = "mason-org/mason.nvim" })
  plug("mason")

  -- Formatter
  add({ source = "stevearc/conform.nvim" })
  plug("conform")
end)

-- UI --------------------------------------------------------------------------
later(function()
  -- Animated highlights
  add({ source = "rachartier/tiny-glimmer.nvim" })
  plug("tiny-glimmer")

  -- Diagnostics
  add({ source = "rachartier/tiny-inline-diagnostic.nvim" })
  plug("tiny-inline-diagnostic")
end)

-- Quickfix --------------------------------------------------------------------
later(function()
  add({ source = "stevearc/quicker.nvim" })
  plug("quicker")
end)

-- Editor ----------------------------------------------------------------------
later(function()
  -- Multicursor
  add({ source = "jake-stewart/multicursor.nvim" })
  plug("multicursor")
end)

-- Work ------------------------------------------------------------------------
now(function()
  local work = vim.fn.stdpath("config") .. "/work/init.lua"
  if vim.uv.fs_stat(work) then dofile(work) end
end)
