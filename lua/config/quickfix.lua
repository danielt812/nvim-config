vim.api.nvim_create_user_command("Grep", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
end, { nargs = "+" })

-- stylua: ignore start
local open_qf_list  = function() vim.cmd("copen")    end
local close_qf_list = function() vim.cmd("cclose")   end
local clear_qf_list = function() vim.cmd("cexpr []") end
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set({ "n", "x" }, "<leader>qo", open_qf_list,  { desc = "Open" })
vim.keymap.set({ "n", "x" }, "<leader>qc", close_qf_list, { desc = "Close" })
vim.keymap.set({ "n", "x" }, "<leader>qr", clear_qf_list, { desc = "Clear" })
-- stylua: ignore end
