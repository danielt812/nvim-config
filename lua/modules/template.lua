-- #############################################################################
-- #                              Module Template                              #
-- #############################################################################

local Module = {}
local H = {}

Module.setup = function(config)
  -- Export module
  _G.Module = Module

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

Module.config = {
  mappings = {}
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(Module.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")

  return config
end

H.apply_config = function(config)
  Module.config = config

  -- Mappings/Autocmds/Usercmds go here
  H.apply_autocommands(config)

  -- Put this into keymaps.lua
  vim.keymap.set("n", "<C-r>", function()
    package.loaded["modules.template"] = nil
    require("modules.template").setup()
    vim.notify("modules.template reloaded")
  end, { desc = "Reload Template Module" })
end

-- Autocommands ----------------------------------------------------------------
H.apply_autocommands = function(config)
  local group = vim.api.nvim_create_augroup("Module", { clear = true })

  local au = function(event, pattern, callback, desc)
    vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
  end
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(module.template) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return Module
