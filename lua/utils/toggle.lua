local M = {}

M.toggle_wrap = function()
  if vim.opt.wrap:get() == true then
    vim.opt_local.wrap = false
  else
    vim.opt_local.wrap = true
  end
end

M.toggle_relativenumber = function()
  if vim.opt.relativenumber:get() == true then
    vim.opt_local.relativenumber = false
  else
    vim.opt_local.relativenumber = true
  end
end

M.toggle_hlsearch = function()
  if vim.opt.hlsearch:get() == true then
    vim.opt_local.hlsearch = false
  else
    vim.opt_local.hlsearch = true
  end
end

M.toggle_spell = function()
  if vim.opt.spell:get() == true then
    vim.opt_local.spell = false
  else
    vim.opt_local.spell = true
  end
end

M.toggle_ignorecase = function()
  if vim.opt.ignorecase:get() == true then
    vim.opt_local.ignorecase = false
  else
    vim.opt_local.ignorecase = true
  end
end

M.toggle_diagnostic = function()
  if vim.diagnostic.is_enabled() == true then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable(true)
  end
end

return M
