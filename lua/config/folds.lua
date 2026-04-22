vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function() vim.opt.fillchars:append({ fold = " " }) end,
})

local function hl_line(parts, buf, row, line, skip_ws)
  local byte_col = 0
  local ws = skip_ws and #(line:match("^%s*")) or 0

  for _, char in ipairs(vim.fn.split(line, "\\zs")) do
    local len = #char
    if byte_col >= ws then
      local captures = vim.treesitter.get_captures_at_pos(buf, row, byte_col)
      if #captures > 0 then
        local last = captures[#captures]
        table.insert(parts, { char, "@" .. last.capture .. "." .. last.lang })
      else
        table.insert(parts, { char })
      end
    end
    byte_col = byte_col + len
  end
end

function _G.foldtext()
  local buf = vim.api.nvim_get_current_buf()
  local start_line = vim.fn.getbufline(buf, vim.v.foldstart)[1]
  local end_line = vim.fn.getbufline(buf, vim.v.foldend)[1]
  local parts = {}
  table.insert(parts, { "󰘖 ", "Orange" })

  -- Start line: per-character treesitter highlights
  hl_line(parts, buf, vim.v.foldstart - 1, start_line, false)

  -- Delimiter
  for _, char in ipairs(vim.fn.split(" ... ", "\\zs")) do
    table.insert(parts, { char, "Folded" })
  end

  -- End line: skip leading whitespace, then per-character treesitter highlights
  hl_line(parts, buf, vim.v.foldend - 1, end_line, true)

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
