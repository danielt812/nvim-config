local enabled = true
return {
  toggle_rel = function()
    local rel = vim.opt.relativenumber:get()
    if rel == true then
      vim.opt_local.relativenumber = false
      vim.notify("Relative Number disabled")
    else
      vim.opt_local.relativenumber = true
      vim.notify("Relative Number enabled")
    end
  end,
  toggle_hl = function()
    local hl = vim.opt.hlsearch:get()
    if hl == true then
      vim.opt_local.hlsearch = false
      vim.notify("Highlight disabled")
    else
      vim.opt_local.hlsearch = true
      vim.notify("Highlight enabled")
    end
  end,
  toggle_spell = function()
    local spell = vim.opt.spell:get()
    if spell == true then
      vim.opt_local.spell = false
      vim.notify("Spell Check disabled")
    else
      vim.opt_local.spell = true
      vim.notify("Spell Check enabled")
    end
  end,
  toggle_wrap = function()
    local wrap = vim.opt.wrap:get()
    if wrap == true then
      vim.opt_local.wrap = false
      vim.notify("Wrap disabled")
    else
      vim.opt_local.wrap = true
      vim.notify("Wrap enabled")
    end
  end,
  toggle_case = function()
    local case = vim.opt.ignorecase:get()
    if case == true then
      vim.opt_local.ignorecase = false
      vim.notify("Case Insensitive disabled")
    else
      vim.opt_local.ignorecase = true
      vim.notify("Case Insensitive enabled")
    end
  end,
  toggle_diagnostic = function()
    enabled = not enabled
    if enabled then
      vim.diagnostic.enable()
      vim.notify("Diagnostics enabled")
    else
      vim.diagnostic.disable()
      vim.notify("Diagnostics disabled")
    end
  end,
}
