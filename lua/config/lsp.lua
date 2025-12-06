-- Shared capabilities
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("mini.completion").get_lsp_capabilities(),
  {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }
)

-- Shared on_attach
local function on_attach(client, bufnr)
  if client.server_capabilities.semanticTokensProvider then
    client.server_capabilities.semanticTokensProvider = nil
  end

  local function map(mode, lhs, rhs, key_opts)
    key_opts = key_opts or {}
    key_opts.silent = key_opts.silent ~= false
    key_opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, key_opts)
  end

  -- stylua: ignore start
  map("n", "K",          "<cmd>lua vim.lsp.buf.hover()<cr>",           { desc = "Hover" })
  map("n", "g.",         "<cmd>lua vim.lsp.buf.format()<cr>",          { desc = "Format" })
  map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",     { desc = "Code Action" })
  map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>",      { desc = "Definition" })
  map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",          { desc = "Rename" })
  map("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>",  { desc = "Implementation" })
  map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>",  { desc = "Signature Help" })
  map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type Definition" })
  map("n", "<leader>le", "<cmd>lua vim.lsp.buf.references()<cr>",      { desc = "References" })
  -- stylua: ignore end

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(false)
  end
end

-- List of servers to enable
local servers = {
  "angularls",
  "bashls",
  "cssls",
  "css_variables",
  "cssmodules_ls",
  "dockerls",
  "emmet_language_server",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  "tsgo",
  "yamlls",
}

-- Register each server configuration under vim.lsp.configs
for _, name in ipairs(servers) do
  local ok, conf = pcall(require, "lsp." .. name)
  if not ok then
    vim.notify("Failed to load LSP config: lsp." .. name, vim.log.levels.WARN)
    conf = {}
  end

  vim.lsp.config[name] = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, conf or {})
end

-- Enable them all
vim.lsp.enable(servers)

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("checkhealth lsp")
end, {})

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("edit " .. vim.lsp.get_log_path())
end, { desc = "Open Neovim LSP log file" })
