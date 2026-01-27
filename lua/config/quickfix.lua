vim.api.nvim_create_user_command("Grep", function(opts)
  local escaped = vim.tbl_map(vim.fn.shellescape, opts.fargs)

  local cmd = "silent grep! " .. table.concat(escaped, " ")

  vim.cmd(cmd)
  vim.cmd("copen")
end, {
  nargs = "+",
  desc = "ripgrep (safe, supports flags, respects ripgrep.conf)",
})

local function clear_qf_list()
  vim.cmd("cexpr []")
  vim.cmd("cclose")
end

local function set_diagnostics() vim.diagnostic.setqflist({ bufnr = 0 }) end

local function toggle_qf_list()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>qd", set_diagnostics, { desc = "Diagnostics" })
-- vim.keymap.set("n", "<leader>qq", toggle_qf_list,  { desc = "Quickfix" })
vim.keymap.set("n", "<leader>qc", clear_qf_list,   { desc = "Clear" })
-- stylua: ignore end

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("quickfix_grep", { clear = true }),
  pattern = { "grep", "lgrep" },
  desc = "Auto open/close qf/loc list",
  callback = function(args)
    local is_loc = args.match == "lgrep"

    if is_loc then
      local win = vim.api.nvim_get_current_win()
      local items = vim.fn.getloclist(win)

      if #items > 0 then
        vim.cmd("lopen")
      else
        vim.cmd("lclose")
      end
    else
      local items = vim.fn.getqflist()

      if #items > 0 then
        vim.cmd("copen")
      else
        vim.cmd("cclose")
      end
    end
  end,
})
