-- vim.api.nvim_create_user_command("Grep", function(opts)
--   -- opts.fargs is already shell-parsed and quote-aware
--   local escaped = vim.tbl_map(vim.fn.shellescape, opts.fargs)

--   local cmd = "silent grep! " .. table.concat(escaped, " ")

--   vim.cmd(cmd)
--   vim.cmd("copen")
-- end, {
--   nargs = "+",
--   desc = "ripgrep (safe, supports flags, respects ripgrep.conf)",
-- })


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
