vim.api.nvim_create_user_command("Grep", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
end, { nargs = "+" })

local function open_qf_list()
  vim.cmd("copen")
end

local function close_qf_list()
  vim.cmd("cclose")
end

local function clear_qf_list()
  vim.cmd("cexpr []")
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
vim.keymap.set("n", "<leader>qc", close_qf_list,   { desc = "Close" })
vim.keymap.set("n", "<leader>qd", set_diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>qo", open_qf_list,    { desc = "Open" })
vim.keymap.set("n", "<leader>qq", toggle_qf_list,  { desc = "Toggle" })
vim.keymap.set("n", "<leader>qr", clear_qf_list,   { desc = "Clear" })
-- stylua: ignore end
