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
-- @param msg string: The error message to display.
local delayed_notify = function(msg)
  vim.schedule(function()
    vim.defer_fn(function()
      vim.notify(msg, vim.log.levels.ERROR)
    end, 100) -- delay in ms; adjust if needed
  end)
end

--- Loads a module from the `plugins` namespace with error handling.
-- @param plugin string: Name of the plugin module (without the "plugins." prefix).
local plug = function(plugin)
  local ok, err = pcall(require, "plugins." .. plugin)
  if not ok then
    delayed_notify("Failed to load plugin module: plugins." .. plugin .. "\n" .. err)
  end
end

--- Loads a module from the `mini_plugins` namespace with error handling.
-- @param plugin string: Name of the plugin module (without the "mini_plugins." prefix).
local mplug = function(plugin)
  local ok, err = pcall(require, "mini_plugins." .. plugin)
  if not ok then
    delayed_notify("Failed to load plugin module: mini_plugins." .. plugin .. "\n" .. err)
  end
end

--- Loads a configuration module from the `config` namespace with error handling.
-- @param config string: Name of the config module (without the "config." prefix).
local conf = function(config)
  local ok, err = pcall(require, "config." .. config)
  if not ok then
    delayed_notify("Failed to load config file: config." .. config .. "\n" .. err)
  end
end

local disabled_built_ins = {
  "netrwPlugin",
  "netrw",
  "netrwSettings",
  "netrwFileHandlers",
  "tutor",
}

now(function()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end

  add({ source = "b0o/SchemaStore.nvim" })

  conf("options")
  conf("keymaps")
  conf("autocmds")
  conf("lsp")
  conf("diagnostics")
  conf("quickfix")

  vim.cmd("colorscheme everforest")
end)

-- Mini modules now
now(function()
  mplug("basics")
  mplug("notify")
  mplug("starter")
  mplug("sessions")
  mplug("snippets")
end)

-- Mini modules later
later(function()
  mplug("ai")
  mplug("align")
  mplug("animate")
  mplug("bufremove")
  mplug("clue")
  mplug("cmdline")
  mplug("colors")
  mplug("comment")
  mplug("completion")
  mplug("cursorword")
  mplug("diff")
  mplug("extra")
  mplug("files")
  mplug("git")
  mplug("hipatterns")
  mplug("icons")
  -- mplug("indentscope")
  mplug("jump")
  mplug("jump2d")
  mplug("keymap")
  mplug("map")
  mplug("misc")
  mplug("move")
  mplug("operators")
  -- mplug("pairs") -- Going to try this again, can't get it to behave how I am wanting yet
  mplug("pick")
  mplug("snippets")
  mplug("splitjoin")
  mplug("statusline")
  mplug("surround")
  mplug("tabline")
  mplug("trailspace")
end)

-- Shared dependencies
later(function()
  add({ source = "nvim-lua/plenary.nvim" })
  add({ source = "MunifTanjim/nui.nvim" })
end)

-- Filetype rendering
now(function()
  add({ source = "OXY2DEV/markview.nvim" })
  add({ source = "OXY2DEV/helpview.nvim" })
end)

-- Formatting/Linting
later(function()
  -- add({ source = "nvimtools/none-ls.nvim" })
  -- plug("null-ls")

  add({ source = "stevearc/conform.nvim" })
  plug("conform")
end)

-- Autopair/Autotag
later(function()
  add({ source = "windwp/nvim-autopairs" })
  add({ source = "windwp/nvim-ts-autotag" })
  plug("autopairs")
  plug("autotag")
end)

-- Window movement
later(function()
  add({ source = "aserowy/tmux.nvim" })
  plug("tmux")
end)

-- Debugging
later(function()
  add({
    source = "igorlfs/nvim-dap-view",
    depends = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
    },
  })
  plug("dap")
end)

-- Git
later(function()
  add({ source = "FabijanZulj/blame.nvim" })
  plug("blame")
end)

-- Executables package manager
later(function()
  -- Mason
  add({ source = "mason-org/mason.nvim" })
  plug("mason")
end)

-- Treesitter
later(function()
  add({ source = "nvim-treesitter/nvim-treesitter" })
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })
  add({ source = "JoosepAlviste/nvim-ts-context-commentstring" })
  add({ source = "Wansmer/treesj" })
  plug("treesitter")
  plug("treesj")
end)

-- UI
later(function()
  -- Indentation
  add({ source = "shellRaining/hlchunk.nvim" })
  plug("hlchunk")

  -- Trailing cursor
  add({ source = "sphamba/smear-cursor.nvim" })
  plug("smear-cursor")

  -- Animated highlights
  add({ source = "rachartier/tiny-glimmer.nvim" })
  plug("tiny-glimmer")

  -- Diagnostics
  add({ source = "rachartier/tiny-inline-diagnostic.nvim" })
  plug("tiny-inline-diagnostic")

  -- Quickfix
  add({ source = "stevearc/quicker.nvim" })
  plug("quicker")

  -- Task runner
  add({ source = "stevearc/overseer.nvim" })
  plug("overseer")

  -- Rainbow delimeters
  add({ source = "HiPhish/rainbow-delimiters.nvim" })
  plug("rainbow-delimeters")
end)

-- Editor
later(function()
  -- Highlight unique f and t targets
  -- add({
  --   source = "jinh0/eyeliner.nvim",
  --   depends = { "mawkler/demicolon.nvim" },
  -- })
  -- plug("eyeliner")

  add({ source = "esmuellert/codediff.nvim" })

  -- Search and replace
  add({ source = "MagicDuck/grug-far.nvim" })
  plug("grug-far")

  -- Buffer marks
  add({ source = "chentoast/marks.nvim" })
  plug("marks")

  -- Prettier folds
  add({
    source = "kevinhwang91/nvim-ufo",
    depends = { "kevinhwang91/promise-async" },
  })
  plug("ufo")

  add({ source = "mg979/vim-visual-multi" })
end)

-- LSP extras
later(function()
  -- Winbar breadcrumbs
  add({ source = "SmiteshP/nvim-navic" })
  -- Symbol navigation
  add({ source = "SmiteshP/nvim-navbuddy" })
  plug("nav")
end)

-- Terminal
later(function()
  add({ source = "akinsho/toggleterm.nvim" })
  plug("toggleterm")
end)

-- Co-pilot
later(function()
  add({
    source = "CopilotC-Nvim/CopilotChat.nvim",
    depends = {
      "zbirenbaum/copilot.lua",
    },
    hooks = {
      post_install = function(spec)
        vim.fn.system({ "make", "tiktoken" }, spec.path)
      end,
    },
  })
  plug("copilot-chat")
end)
