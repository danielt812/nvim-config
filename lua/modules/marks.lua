-- #############################################################################
-- #                               Marks Module                                #
-- #############################################################################

local M = {}
local H = {}

M.setup = function(config)
  -- Export module
  _G.ModuleMarks = M

  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)

  -- Set up autocmds
  H.apply_autocmds()

  -- Create default highlighting
  H.create_default_hl()

  H.clear_namespace(0, H.ns_id)
end

M.config = {
  mappings = {
    del = "dm",
    get = "'",
    set = "m",
  },
  priority = 2,
}

-- Helper Data -----------------------------------------------------------------
H.default_config = vim.deepcopy(M.config)

H.setup_config = function(config)
  H.check_type("config", config, "table", true)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  H.check_type("mappings", config.mappings, "table")
  H.check_type("mappings.del", config.mappings.del, "string")
  H.check_type("mappings.get", config.mappings.get, "string")
  H.check_type("mappings.set", config.mappings.set, "string")

  H.check_type("priority", config.priority, "number")

  return config
end

H.apply_config = function(config)
  M.config = config

  -- stylua: ignore start
  H.map("n", config.mappings.del, H.delete_mark,  { desc = "Delete Mark" })
  H.map("n", config.mappings.get, H.jump_to_mark, { desc = "Get Mark" })
  H.map("n", config.mappings.set, H.set_mark,     { desc = "Set Mark" })
  -- stylua: ignore end
  H.map("n", "<leader>ms", H.set_buf_ext_marks, { desc = "Set Buf Ext Marks" })
  H.map("n", "<leader>mg", H.get_buf_ext_marks, { desc = "Get Buf Ext Marks" })
  H.map("n", "<leader>md", H.del_buf_ext_marks, { desc = "Del Buf Ext Marks" })
  H.map("n", "<leader>mn", H.clear_namespace, { desc = "Clear Namespace" })
  H.map("n", "<leader>mp", H.print_cache, { desc = "Print Cache" })

  vim.keymap.set("n", "<C-r>", function()
    package.loaded["modules.marks"] = nil
    require("modules.marks").setup()
    vim.notify("modules.marks reloaded")
  end, { desc = "Reload Marks Module" })
end

H.apply_autocmds = function()
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
      vim.schedule(function()
        H.set_buf_cache()
        H.set_buf_ext_marks()
      end)
    end,
  })
end

-- Helper Functionality --------------------------------------------------------
H.cache = {}
H.ns_id = vim.api.nvim_create_namespace("ModuleMarks")

H.print_cache = function() print(vim.inspect(H.cache)) end

H.set_buf_cache = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf_id in ipairs(bufs) do
    if H.validate_buf_id(buf_id) and not H.cache[buf_id] then H.cache[buf_id] = {} end
  end
end

H.get_buf_ext_marks = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local extmarks = vim.api.nvim_buf_get_extmarks(buf_id, H.ns_id, 0, -1, {})
  return extmarks
end

H.set_buf_ext_marks = function()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf_id in ipairs(bufs) do
    local marks = vim.fn.getmarklist(buf_id)

    for _, mark in ipairs(marks) do
      local char = mark.mark:sub(-1)
      local pos = mark.pos -- {buf_id, lnum, col, off}

      local extmark_opts = { sign_text = char, sign_hl_group = "ModuleMarkSign", priority = 200 }

      if char:match("[a-z]") then
        local lnum = pos[2]
        local extmark_id = vim.api.nvim_buf_set_extmark(buf_id, H.ns_id, lnum - 1, 0, extmark_opts)
        if H.validate_buf_id(buf_id) then
          if not H.cache[buf_id] then H.cache[buf_id] = {} end
          H.cache[buf_id][char] = extmark_id
        end
      end
    end
  end
end

H.del_buf_ext_marks = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local extmarks = H.get_buf_ext_marks()

  for _, extmark in ipairs(extmarks) do
    local extmark_id = extmark[1]
    vim.api.nvim_buf_del_extmark(buf_id, H.ns_id, extmark_id)
  end
end

H.create_default_hl = function()
  local hi = function(name, opts)
    opts.default = true
    vim.api.nvim_set_hl(0, name, opts)
  end

  hi("ModuleMarkSign", { link = "Constant" })
end

H.clear_namespace = function(buf_id, ns_id)
  buf_id = vim.api.nvim_get_current_buf()
  ns_id = ns_id or H.ns_id
  pcall(vim.api.nvim_buf_clear_namespace, buf_id, ns_id, 0, -1)
end

H.extmark_set = function(char, buf_id, ns_id, row, col)
  local opts = { sign_text = char, sign_hl_group = "ModuleMarkSign", priority = M.config.priority }
  return vim.api.nvim_buf_set_extmark(buf_id, ns_id, row, col, opts)
end

H.delete_mark = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local char = vim.fn.getcharstr()

  local mark_deleted = pcall(vim.api.nvim_buf_del_mark, buf_id, char)
  if not mark_deleted then return end

  if H.cache[buf_id][char] then
    vim.api.nvim_buf_del_extmark(buf_id, H.ns_id, H.cache[buf_id][char])
    H.cache[buf_id][char] = nil
  end
end

H.set_mark = function()
  local char = vim.fn.getcharstr()
  local win_id = vim.api.nvim_get_current_win()
  local buf_id = vim.api.nvim_get_current_buf()
  local ns_id = H.ns_id

  local row, col = unpack(vim.api.nvim_win_get_cursor(win_id))

  local prev_cache = H.cache[buf_id][char]

  local mark_set = pcall(vim.api.nvim_buf_set_mark, 0, char, row, col, {})
  if not mark_set then return end
  -- Delete previous mark sign if mark_set is successful
  if prev_cache then vim.api.nvim_buf_del_extmark(0, ns_id, prev_cache) end

  local extmark_id = H.extmark_set(char, buf_id, H.ns_id, row - 1, 0)

  H.cache[buf_id][char] = extmark_id
end

H.jump_to_mark = function()
  local char = vim.fn.getcharstr()
  local win_id = vim.api.nvim_get_current_win()
  local mark = vim.api.nvim_buf_get_mark(0, char) -- {row, col}

  if mark[1] == 0 then return end

  vim.api.nvim_win_set_cursor(win_id, mark)
end

-- Validators ------------------------------------------------------------------
H.validate_buf_id = function(x)
  if x == nil or x == 0 then return vim.api.nvim_get_current_buf() end
  if not (type(x) == "number" and vim.api.nvim_buf_is_valid(x)) then
    H.error("`buf_id` should be `nil` or valid buffer id.")
  end
  return x
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
