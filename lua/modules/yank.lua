-- #############################################################################
-- #                                Yank Module                                #
-- #############################################################################

local ModuleYank = {}
local H = {}

--- Module setup
---
---@param config table|nil Module config table. See |ModuleYank.config|.
---
---@usage >lua
---   require('modules.yank').setup() -- use default config
---   -- OR
---   require('modules.yank').setup({}) -- replace {} with your config table
--- <
ModuleYank.setup = function(config)
  -- Export module
  _G.ModuleYank = ModuleYank

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

ModuleYank.config = {
  mappings = {},

  yank = {
    preserve_cursor = true,
  },

  history = {
    enabled = true,

    directory = vim.fn.stdpath("data") .. "/yanks",
  },
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModuleYank.config)

H.cache = {
  cursor_pos = nil,
}

H.history = {
  items = {},
}

-- Helper functionality --------------------------------------------------------
H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("yank", config.yank, "table")
  H.check_type("yank.preserve_cursor", config.yank.preserve_cursor, "boolean")

  H.check_type("history", config.history, "table")
  H.check_type("history.directory", config.history.directory, "string")
  H.check_type("history.enabled", config.history.enabled, "boolean")

  return config
end

H.apply_config = function(config)
  ModuleYank.config = config

  if config.yank.preserve_cursor then
    local preserve_y = function() return H.preserve_cursor("y") end
    local preserve_Y = function() return H.preserve_cursor("Y") end
    H.map({ "n", "v" }, "y", preserve_y, { expr = true })
    H.map({ "n", "v" }, "Y", preserve_Y, { expr = true })
  end

  H.apply_autocommands(config)
end

H.get_map_info = function(mode, lhs)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, info in ipairs(keymaps) do
    if info.lhs == lhs then return info end
  end
end

-- Yank ------------------------------------------------------------------------
H.preserve_cursor = function(key)
  H.cache.cursor_pos = vim.api.nvim_win_get_cursor(0)
  return key
end

H.get_event_reg = function()
  local r = vim.v.event.regname
  return (r ~= nil and r ~= "") and r or '"'
end

H.get_reg_lines = function(reg) return vim.fn.getreg(reg, 1) end

H.is_yank_event = function() return vim.v.event.operator == "y" end

-- Autocommands ----------------------------------------------------------------
H.apply_autocommands = function(config)
  local augroup = vim.api.nvim_create_augroup("ModuleYank", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = augroup, pattern = pattern, callback = callback, desc = desc })
  end

  if config.yank.preserve_cursor then
    local preserve_cursor = function()
      if H.is_yank_event and H.cache.cursor_pos then
        vim.api.nvim_win_set_cursor(0, H.cache.cursor_pos)
        H.cache.cursor_pos = nil
      end
    end
    au("TextYankPost", "*", preserve_cursor, "Preserve cursor position on yank")
  end

  if config.history.enabled then
    local dir = config.history.directory
    local update_hist_cache = function()
      if H.is_yank_event then
      end
    end
    au("TextYankPost", "*", update_hist_cache, "Save yank to history file")
  end
end

-- Utilities -------------------------------------------------------------------
H.error = function(msg) error("(module.yank) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return ModuleYank
