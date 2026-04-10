vim.api.nvim_create_user_command("PackUpdate", function() vim.pack.update() end, { desc = "Update plugins" })

vim.api.nvim_create_user_command("PackClean", function()
  local active, unused = {}, {}
  for _, plugin in ipairs(vim.pack.get()) do
    active[plugin.spec.name] = plugin.active
  end

  for _, plugin in ipairs(vim.pack.get()) do
    if not active[plugin.spec.name] then table.insert(unused, plugin.spec.name) end
  end

  if #unused == 0 then
    vim.api.nvim_echo({ { "vim.pack: ", "OkMsg" }, { "Nothing to clean" } }, true, {})
    return
  end

  local choice = vim.fn.confirm("Clean:" .. table.concat(unused, ", ") .. "?", "&Yes\n&No", 2)

  if choice == 1 then vim.pack.del(unused) end
end, { desc = "Delete unused plugins" })
