function _G.foldtext()
  local buf = vim.api.nvim_get_current_buf()
  local start_line = vim.fn.getbufline(buf, vim.v.foldstart)[1]
  local end_line = vim.fn.getbufline(buf, vim.v.foldend)[1]
  local parts = {}
  table.insert(parts, { "󰘖 ", "Keyword" })

  -- Start line: per-character treesitter highlights
  for p, char in ipairs(vim.fn.split(start_line, "\\zs")) do
    local captures = vim.treesitter.get_captures_at_pos(buf, vim.v.foldstart - 1, p - 1)

    if #captures > 0 then
      local last = captures[#captures]
      table.insert(parts, { char, "@" .. last.capture .. "." .. last.lang })
    else
      table.insert(parts, { char })
    end
  end

  -- Delimiter
  for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
    table.insert(parts, { char, "Folded" })
  end

  -- End line: skip leading whitespace, then per-character treesitter highlights
  local whitespace = vim.fn.strchars(string.match(end_line, "^%s*"))

  for p, char in ipairs(vim.fn.split(end_line, "\\zs")) do
    if p > whitespace then
      local captures = vim.treesitter.get_captures_at_pos(buf, vim.v.foldend - 1, p - 1)

      if #captures > 0 then
        local last = captures[#captures]
        table.insert(parts, { char, "@" .. last.capture .. "." .. last.lang })
      else
        table.insert(parts, { char })
      end
    end
  end

  -- Fold size
  local size = (vim.v.foldend - vim.v.foldstart) + 1
  table.insert(parts, { tostring(" " .. size) })
  table.insert(parts, { " lines", "Folded" })

  return parts
end

vim.keymap.set("n", "zt", function()
  if vim.w.folds_closed then
    vim.cmd("normal! zR")
    vim.w.folds_closed = false
  else
    vim.cmd("normal! zM")
    vim.w.folds_closed = true
  end
end, { desc = "Toggle all folds" })
