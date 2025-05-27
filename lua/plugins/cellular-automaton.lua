local cmd = function(cmd, func)
  return vim.api.nvim_create_user_command(cmd, func, {})
end

cmd("FML", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ts_ok = pcall(vim.treesitter.get_parser, bufnr)

  if not ts_ok then
    vim.notify("Treesitter is not available for this buffer", vim.log.levels.WARN)
    return
  end

  vim.cmd("CellularAutomaton make_it_rain")
end)

cmd("GOL", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ts_ok = pcall(vim.treesitter.get_parser, bufnr)

  if not ts_ok then
    vim.notify("Treesitter is not available for this buffer", vim.log.levels.WARN)
    return
  end

  vim.cmd("CellularAutomaton game_of_life")
end)
