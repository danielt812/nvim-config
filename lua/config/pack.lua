vim.api.nvim_create_user_command("PackUpdate", function(args)
  if #args.fargs > 0 then
    vim.pack.update(args.fargs, { force = args.bang })
  else
    vim.pack.update(nil, { force = args.bang })
  end
end, { bang = true, nargs = "*", desc = "Update plugins" })

vim.api.nvim_create_user_command("PackClean", function(args)
  local managed = {}
  for _, plug in ipairs(vim.pack.get()) do
    managed[plug.path] = true
  end

  local pack_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt"
  local unused = {}
  for name, kind in vim.fs.dir(pack_dir) do
    if kind == "directory" then
      local path = pack_dir .. "/" .. name
      if not managed[path] then
        table.insert(unused, name)
      end
    end
  end

  if #unused == 0 then
    vim.notify("Nothing to clean", vim.log.levels.INFO)
    return
  end

  if args.bang then
    vim.pack.del(unused, { force = true })
    vim.notify("Deleted: " .. table.concat(unused, ", "), vim.log.levels.INFO)
  else
    vim.ui.select(
      { "Yes", "No" },
      { prompt = "Delete " .. #unused .. " unused plugins? (" .. table.concat(unused, ", ") .. ")" },
      function(choice)
        if choice == "Yes" then
          vim.pack.del(unused, { force = true })
          vim.notify("Deleted: " .. table.concat(unused, ", "), vim.log.levels.INFO)
        end
      end
    )
  end
end, { bang = true, desc = "Delete unused plugins" })
