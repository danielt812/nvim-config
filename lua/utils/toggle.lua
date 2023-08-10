local enabled = true
return {
  toggle_rel = function()
    local rel = vim.opt.relativenumber:get()
    if rel == true then
      vim.opt_local.relativenumber = false
    else
      vim.opt_local.relativenumber = true
    end
  end,
  toggle_hl = function()
    local hl = vim.opt.hlsearch:get()
    if hl == true then
      vim.opt_local.hlsearch = false
    else
      vim.opt_local.hlsearch = true
    end
  end,
  toggle_spell = function()
    local spell = vim.opt.spell:get()
    if spell == true then
      vim.opt_local.spell = false
    else
      vim.opt_local.spell = true
    end
  end,
  toggle_wrap = function()
    local wrap = vim.opt.wrap:get()
    if wrap == true then
      vim.opt_local.wrap = false
    else
      vim.opt_local.wrap = true
    end
  end,
  toggle_case = function()
    local case = vim.opt.ignorecase:get()
    if case == true then
      vim.opt_local.ignorecase = false
    else
      vim.opt_local.ignorecase = true
    end
  end,
  toggle_diagnostic = function()
    enabled = not enabled
    if enabled then
      vim.diagnostic.enable()
    else
      vim.diagnostic.disable()
    end
  end,
}
