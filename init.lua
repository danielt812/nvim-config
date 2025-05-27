-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
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

  conf("options")
  conf("keymaps")
  conf("autocmds")

  vim.cmd("colorscheme everforest")
end)

-- Mini modules now
now(function()
  mplug("basics")
  mplug("notify")
  mplug("starter")
  mplug("sessions")
  mplug("sessions")
end)

-- Mini modules later
later(function()
  mplug("ai")
  mplug("align")
  mplug("animate")
  mplug("bufremove")
  mplug("clue")
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

-- Autopair/Autotag
later(function()
  add({ source = "windwp/nvim-autopairs" })
  add({ source = "windwp/nvim-ts-autotag" })

  plug("autopairs")
  plug("autotag")
end)

-- Filetype rendering
later(function()
  add({ source = "OXY2DEV/markview.nvim" })
  add({ source = "OXY2DEV/helpview.nvim" })
end)

later(function()
  add({ source = "aserowy/tmux.nvim" })
  plug("tmux")
end)

-- Debugging
later(function()
  add({
    source = "mfussenegger/nvim-dap",
    depends = {
      "jbyuki/one-small-step-for-vimkind",
    },
  })
  add({ source = "igorlfs/nvim-dap-view" })
  plug("dap")
end)

-- LSP
later(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "folke/lazydev.nvim" },
  })
  plug("lspconfig")

  add({
    source = "nvimtools/none-ls.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })
  plug("null-ls")

  -- NOTE - trying completion, but keeping this here incase I want additional sources
  -- add({
  --   source = "saghen/blink.cmp",
  --   depends = {
  --     "zbirenbaum/copilot.lua",
  --     "giuxtaposition/blink-cmp-copilot",
  --   },
  -- })
  -- plug("blink")
end)

later(function()
  add({ source = "FabijanZulj/blame.nvim" })
  add({ source = "f-person/git-blame.nvim" })

  plug("blame")
end)

later(function()
  -- Mason
  add({
    source = "mason-org/mason.nvim",
    depends = {
      "mason-org/mason-lspconfig.nvim",
      "mason-org/mason-registry",
      "jay-babu/mason-null-ls.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    hooks = {
      post_checkout = function()
        vim.cmd("MasonUpdate")
      end,
    },
  })
  plug("mason")
end)

-- Treesitter
later(function()
  add({ source = "nvim-treesitter/nvim-treesitter" })
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })
  add({ source = "JoosepAlviste/nvim-ts-context-commentstring" })

  plug("treesitter")
end)

-- UI
later(function()
  -- Indention guides and scope
  add({ source = "shellRaining/hlchunk.nvim" })
  plug("hlchunk")

  -- Extra animations
  add({ source = "rachartier/tiny-glimmer.nvim" })
  plug("tiny-glimmer")

  -- Trailing cursor
  add({ source = "sphamba/smear-cursor.nvim" })
  plug("smear-cursor")

  -- Rainbow parenthesis, brackets, curly
  add({ source = "HiPhish/rainbow-delimiters.nvim" })
  plug("rainbow-delimeters")

  -- Rainbow csv
  add({ source = "cameron-wags/rainbow_csv.nvim" })
end)

-- Fast selection menus
later(function()
  add({ source = "leath-dub/snipe.nvim" })
  add({ source = "Chaitanyabsprip/fastaction.nvim" })

  plug("fastaction")
  plug("snipe")
end)

-- Editor
later(function()
  -- Highlight unique f and t targets
  add({
    source = "jinh0/eyeliner.nvim",
    depends = { "mawkler/demicolon.nvim" },
  })
  plug("eyeliner")

  -- Line peek
  add({ source = "nacro90/numb.nvim" })
  plug("numb")

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
end)

later(function()
  -- Winbar breadcrumbs
  add({ source = "SmiteshP/nvim-navic" })
  -- Fast symbol navigation
  add({
    source = "SmiteshP/nvim-navbuddy",
    depends = { "MunifTanjim/nui.nvim" },
  })
  plug("nav")
end)

-- For fun
later(function()
  add({ source = "Eandrju/cellular-automaton.nvim" })
  plug("cellular-automaton")
end)

-- Oil for lots file manipulation
later(function()
  add({ source = "stevearc/oil.nvim" })
  plug("oil")
end)
