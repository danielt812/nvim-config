-- #############################################################################
-- #                             Quickfix/LocList                              #
-- #############################################################################

local H = {}

H.grep = function(opts, use_loclist)
  local escaped = vim.tbl_map(vim.fn.shellescape, opts.fargs)
  local base = use_loclist and "lgrep!" or "grep!"
  vim.cmd("silent " .. base .. " " .. table.concat(escaped, " "))

  if use_loclist then
    vim.cmd("lopen")
  else
    vim.cmd("copen")
  end
end

H.clear_qf = function()
  vim.cmd("cexpr []")
  vim.cmd("cclose")
end

H.clear_loc = function()
  local win = vim.api.nvim_get_current_win()
  vim.fn.setloclist(win, {}, "r") -- replace with empty
  vim.cmd("lclose")
end

H.toggle_qf = function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

H.toggle_loc = function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd("lclose")
      return
    end
  end
  vim.cmd("lopen")
end

H.set_diagnostics_qf = function()
  vim.diagnostic.setqflist({ bufnr = 0 })
  -- open/close handled by autocmd because this is QuickFixCmdPost? (it isn't)
  -- so do it explicitly:
  local items = vim.fn.getqflist()
  if #items > 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

H.set_diagnostics_loc = function()
  vim.diagnostic.setloclist({ bufnr = 0 })
  local win = vim.api.nvim_get_current_win()
  local items = vim.fn.getloclist(win)
  if #items > 0 then
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end

-- Commands --------------------------------------------------------------------
vim.api.nvim_create_user_command("Grep", function(opts) H.grep(opts, false) end, {
  nargs = "+",
  desc = "ripgrep -> quickfix (safe, supports flags, respects ripgrep.conf)",
})

vim.api.nvim_create_user_command("LGrep", function(opts) H.grep(opts, true) end, {
  nargs = "+",
  desc = "ripgrep -> loclist (safe, supports flags, respects ripgrep.conf)",
})

-- Keymaps ---------------------------------------------------------------------
-- stylua: ignore start
vim.keymap.set("n", "<leader>qd", H.set_diagnostics_qf,  { desc = "Diagnostics (QF)" })
vim.keymap.set("n", "<leader>qD", H.set_diagnostics_loc, { desc = "Diagnostics (Loc)" })

vim.keymap.set("n", "<leader>qq", H.toggle_qf,           { desc = "Quickfix" })
vim.keymap.set("n", "<leader>ql", H.toggle_loc,          { desc = "Loclist" })

vim.keymap.set("n", "<leader>qc", H.clear_qf,            { desc = "Quickfix clear" })
vim.keymap.set("n", "<leader>qC", H.clear_loc,           { desc = "Loclist clear" })
-- stylua: ignore end
