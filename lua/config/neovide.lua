if vim.g.neovide then
  -- Allow paste from clipboard
  vim.api.nvim_set_keymap("i", "<D-v>", "p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  vim.api.nvim_set_keymap("n", "<D-j>", "<cmd>m .+1<CR>==", { desc = "Move down" })
  vim.api.nvim_set_keymap("n", "<D-k>", "<cmd>m .-2<CR>==", { desc = "Move up" })
  vim.api.nvim_set_keymap("i", "<D-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move down" })
  vim.api.nvim_set_keymap("i", "<D-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move up" })
  vim.api.nvim_set_keymap("v", "<D-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
  vim.api.nvim_set_keymap("v", "<D-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

  -- Change scale of font size
  vim.g.neovide_scale_factor = 1
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.1)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
  end)
end
