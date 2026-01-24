vim.api.nvim_create_user_command("Grep", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
end, { nargs = "+" })

local function clear_qf_list()
  vim.cmd("cexpr []")
  vim.cmd("cclose")
end

local function set_diagnostics()
  vim.diagnostic.setqflist({ bufnr = 0 })
end

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
vim.keymap.set("n", "<leader>qq", toggle_qf_list,  { desc = "Quickfix" })
vim.keymap.set("n", "<leader>qc", clear_qf_list,   { desc = "Clear" })
-- stylua: ignore end
