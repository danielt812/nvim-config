local animation = function(animation)
  local bufnr = vim.api.nvim_get_current_buf()
  local ts_ok = pcall(vim.treesitter.get_parser, bufnr)

  if not ts_ok then
    vim.notify("Treesitter is not available for this buffer", vim.log.levels.WARN)
    return
  end

  vim.cmd("CellularAutomaton" .. " " .. animation)
end

vim.api.nvim_create_user_command("FML", function()
  animation("make_it_rain")
end, {})

vim.api.nvim_create_user_command("GOL", function()
  animation("game_of_life")
end, {})

vim.api.nvim_create_user_command("SCR", function()
  animation("scramble")
end, {})
