vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local misc = require("mini.misc")

-- stylua: ignore start
local now   = function(cb) misc.safely("now", cb) end
local later = function(cb) misc.safely("later", cb) end
-- stylua: ignore end

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
  conf("pack")

  vim.g.colors_variant = "soft"
  vim.cmd("colorscheme everforest")

  -- Mini modules now ------------------------------------------------------------
  mplug("basics")
  mplug("completion")
  mplug("notify")
  mplug("sessions")
  mplug("snippets")
  mplug("starter")
end)

-- Mini modules later ----------------------------------------------------------
later(function()
  mplug("ai")
  mplug("align")
  mplug("animate")
  mplug("bufremove")
  mplug("bracketed")
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
  mplug("visits")
end)

-- Treesitter ------------------------------------------------------------------
now(function()
  vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
  vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })
  plug("tree-sitter")

  -- Rainbow delimeters
  vim.pack.add({ "https://github.com/HiPhish/rainbow-delimiters.nvim" })
  plug("rainbow-delimeters")

  -- Split/join
  vim.pack.add({ "https://github.com/Wansmer/treesj" })
  plug("treesj")
end)

-- Filetype rendering ----------------------------------------------------------
now(function()
  vim.pack.add({ "https://github.com/OXY2DEV/markview.nvim" })
  vim.pack.add({ "https://github.com/OXY2DEV/helpview.nvim" })
end)

-- Debugging -------------------------------------------------------------------
later(function()
  vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
  vim.pack.add({ "https://github.com/igorlfs/nvim-dap-view" })
  plug("dap")
end)

-- Executables -----------------------------------------------------------------
later(function()
  -- Manager
  vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
  plug("mason")

  -- Formatter
  vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
  plug("conform")
end)

-- Quickfix --------------------------------------------------------------------
later(function()
  vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })
  plug("quicker")
end)

-- Editor ----------------------------------------------------------------------
later(function()
  -- Multicursor
  vim.pack.add({ "https://github.com/jake-stewart/multicursor.nvim" })
  plug("multicursor")
end)

-- Rest Client -----------------------------------------------------------------
later(function()
  vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })
  plug("kulala")
end)

-- Work ------------------------------------------------------------------------
now(function()
  local work = vim.fn.stdpath("config") .. "/work/init.lua"
  if vim.uv.fs_stat(work) then dofile(work) end
end)
