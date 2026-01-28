-- #############################################################################
-- #                              Module Template                              #
-- #############################################################################

local M = {}
local H = {}

M.setup = function(config)
  config = H.setup_config(config)
  H.apply_config(config)
end

M.config = {
  mappings = {}
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(M.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")

  return config
end

H.apply_config = function(config)
  M.config = config

  -- Mappings/Autocmds/Usercmds go here

  vim.keymap.set("n", "<C-r>", function()
    package.loaded["modules.template"] = nil
    require("modules.template").setup()
    vim.notify("modules.template reloaded")
  end, { desc = "Reload Template Module" })
end

-- Utils -----------------------------------------------------------------------
H.error = function(msg) error("(module) " .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then return end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
