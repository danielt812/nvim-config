-- #############################################################################
-- #                               Modes Module                                #
-- #############################################################################

local ModModes = {}
local H = {}

--- Module setup
---
---@param config table|nil Module config table. See |ModModes.config|.
---
---@usage >lua
---   require('modules.himode').setup() -- use default config
---   -- OR
---   require('modules.himode').setup({}) -- replace {} with your config table
--- <
ModModes.setup = function(config)
  -- Export module
  _G.ModModes = ModModes

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

ModModes.config = {
  mode = {
    number = true,

    palette = {
      command = "MiniStatuslineModeCommand",
      insert = "MiniStatuslineModeInsert",
      normal = "MiniStatuslineModeNormal",
      replace = "MiniStatuslineModeReplace",
      visual = "MiniStatuslineModeVisual",
      other = "MiniStatuslineModeOther",
    },
  },
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(ModModes.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mode", config.mode, "table")
  H.check_type("mode.number", config.mode.number, "boolean")

  -- stylua: ignore start
  H.check_type("palette",          config.mode.palette,         "table")
  H.check_type("palette.command",  config.mode.palette.command, "string")
  H.check_type("palette.insert",   config.mode.palette.insert,  "string")
  H.check_type("palette.normal",   config.mode.palette.normal,  "string")
  H.check_type("palette.replace",  config.mode.palette.replace, "string")
  H.check_type("palette.visual",   config.mode.palette.visual,  "string")
  H.check_type("palette.other",    config.mode.palette.other,   "string")
  -- stylua: ignore end

  return config
end

H.apply_config = function(config)
  ModModes.config = config

  -- Apply highlights
  H.apply_highlights(config)

  -- Apply autocommands
  H.apply_autocmds(config)
end

H.cache = {}

-- Helper Functionality --------------------------------------------------------
H.link_hl = function(name, link) vim.api.nvim_set_hl(0, name, { link = link }) end

-- stylua: ignore
H.get_hl_property = function(name, property)
  return vim.api.nvim_get_hl(0, { name = name, link = false })[property]
end

H.title_case = function(s)
  if type(s) ~= "string" or s == "" then return s end
  return s:gsub("^%l", string.upper)
end

H.gen_mode_hl_groups = function(config, name, from, to)
  local palette = config.mode.palette

  local modes = { "command", "insert", "normal", "replace", "visual", "other" }

  for _, mode in ipairs(modes) do
    local source_hl = palette[mode]
    local val = H.get_hl_property(source_hl, from)

    if val ~= nil then
      local hl = (to == "fg") and { fg = val } or (to == "bg") and { bg = val } or nil
      if hl then
        vim.api.nvim_set_hl(0, name .. H.title_case(mode), hl)
      end
    end
  end
end

H.link_mode_highlights = function(mode, name)
  mode = mode:lower()

  local m1 = mode:sub(1, 1)
  if m1 == "v" or mode == "\022" then return H.link_hl(name, name .. "Visual") end
  if m1 == "c" then return H.link_hl(name, name .. "Command") end
  if m1 == "i" then return H.link_hl(name, name .. "Insert") end
  if m1 == "n" then return H.link_hl(name, name .. "Normal") end
  if m1 == "r" then return H.link_hl(name, name .. "Replace") end

  return H.link_hl(name, name .. "Other")
end

H.restore_highlights = function(hl_group)
  local opts = H.cache[hl_group]
  if not opts then return end
  vim.api.nvim_set_hl(0, hl_group, opts)
end

H.cache_hl_group = function(hl_group, force)
  if not force and H.cache[hl_group] ~= nil then return end
  local opts = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
  H.cache[hl_group] = vim.deepcopy(opts)
end

-- Highlights ------------------------------------------------------------------
H.apply_highlights = function(config)
  -- stylua: ignore
  if config.mode.number then
    H.cache_hl_group("CursorLineNr")
    H.gen_mode_hl_groups(config, "CursorLineNr", "bg", "fg")
    H.link_mode_highlights(vim.fn.mode(), "CursorLineNr")
  else
    H.restore_highlights("CursorLineNr")
  end
end

-- Autocommands ----------------------------------------------------------------
H.apply_autocmds = function(config)
  local group = vim.api.nvim_create_augroup("ModModes", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end

  if config.mode.number == true then
    local hl_number = function()
      -- stylua: ignore
      H.link_mode_highlights(vim.fn.mode(), "CursorLineNr")
    end
    au("ModeChanged", "*", hl_number, "Modes cursor line number")
  end

  local ensure_colors = function()
    if config.mode.number then H.cache_hl_group("CursorLineNr", true) end
    H.apply_highlights(config)
  end
  au("ColorScheme", "*", ensure_colors, "Ensure colors")
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(module.modes) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return ModModes
