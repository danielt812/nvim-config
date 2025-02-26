local M = {}

M.add_keymaps = function(bufnr)
  local function map(mode, lhs, rhs, key_opts)
    key_opts = key_opts or {}
    key_opts.silent = key_opts.silent ~= false
    key_opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, key_opts)
  end

  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show Hover" })
  map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature Help" })
  map("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to Declaration" })
  map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Definition" })
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to Implementation" })
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to References" })
  -- map("n", "gr", "<cmd>Trouble lsp_references<CR>", { desc = "Go to References" })
  map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to Type Definition" })
  map("n", "<leader>laA", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action  " })
  map("n", "<leader>laf", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format 󰘞 " })
  map("n", "<leader>laD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to Declaration " })
  map("n", "<leader>laR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Definition  " })
  map("n", "<leader>lad", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition 󰊕 " })
  map("n", "<leader>lah", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show Hover  " })
  map("n", "<leader>lai", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to Implementation" })
  map("n", "<leader>lar", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to References" })
  map("n", "<leader>lat", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = "Go to Type Definition  " })
end

return M
