-- #############################################################################
-- #                             Quickfix/LocList                              #
-- #############################################################################

local function clear_qf()
  vim.cmd("cexpr []")
  vim.cmd("cclose")
end

local function clear_loc()
  local win = vim.api.nvim_get_current_win()
  vim.fn.setloclist(win, {}, "r")
  vim.cmd("lclose")
end

local function toggle_qf()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

local function toggle_loc()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd("lclose")
      return
    end
  end
  if #vim.fn.getloclist(0) > 0 then vim.cmd("lopen") end
end

local function set_diagnostics_qf()
  vim.diagnostic.setqflist({ bufnr = 0 })
  local items = vim.fn.getqflist()
  if #items > 0 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end

local function set_diagnostics_loc()
  vim.diagnostic.setloclist({ bufnr = 0 })
  local win = vim.api.nvim_get_current_win()
  local items = vim.fn.getloclist(win)
  if #items > 0 then
    vim.cmd("lopen")
  else
    vim.cmd("lclose")
  end
end

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
vim.keymap.set("n", "<leader>qd", set_diagnostics_qf,  { desc = "Diagnostics (QF)" })
vim.keymap.set("n", "<leader>qD", set_diagnostics_loc, { desc = "Diagnostics (Loc)" })

vim.keymap.set("n", "<leader>qq", toggle_qf,           { desc = "Quickfix" })
vim.keymap.set("n", "<leader>qQ", toggle_loc,          { desc = "Loclist" })

vim.keymap.set("n", "<leader>qc", clear_qf,            { desc = "Quickfix clear" })
vim.keymap.set("n", "<leader>qC", clear_loc,           { desc = "Loclist clear" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("quickfix", { clear = true })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = group,
  pattern = { "grep", "lgrep" },
  desc = "Auto-open quickfix/loclist after grep",
  callback = function(args)
    if args.match == "lgrep" then
      vim.cmd("lopen")
    else
      vim.cmd("copen")
    end
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = group,
  desc = "Close quickfix/loclist when leaving its window",
  callback = function()
    if vim.bo.buftype == "quickfix" then vim.schedule(function() vim.cmd("cclose") vim.cmd("lclose") end) end
  end,
})
