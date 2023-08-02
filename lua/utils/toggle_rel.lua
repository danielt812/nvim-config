return {
  toggle_rel = function()
    local rel = vim.opt.relativenumber:get()
    if rel == true then
      vim.opt_local.relativenumber = false
    else
      vim.opt_local.relativenumber = true
    end
  end,
}
