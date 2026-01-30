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
  -- Prefer treesitter highlighting
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
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

  -- g mappings
  map("n", "gd",  vim.lsp.buf.definition,      { desc = "Go to Definition" })
  map("n", "gla", vim.lsp.buf.code_action,     { desc = "Code Action" })
  map("n", "gld", vim.lsp.buf.definition,      { desc = "Definition" })
  map("n", "glh", vim.lsp.buf.hover,           { desc = "Hover" })
  map("n", "gli", vim.lsp.buf.implementation,  { desc = "Implementation" })
  map("n", "gln", vim.lsp.buf.rename,          { desc = "Rename" })
  map("n", "glr", vim.lsp.buf.references,      { desc = "References" })
  map("n", "gls", vim.lsp.buf.signature_help,  { desc = "Signature Help" })
  map("n", "glt", vim.lsp.buf.type_definition, { desc = "Type Definition" })

  -- leader mappings
  map("n", "<leader>la", vim.lsp.buf.code_action,     { desc = "Code Action" })
  map("n", "<leader>ld", vim.lsp.buf.definition,      { desc = "Definition" })
  map("n", "<leader>lh", vim.lsp.buf.hover,           { desc = "Hover" })
  map("n", "<leader>li", vim.lsp.buf.implementation,  { desc = "Implementation" })
  map("n", "<leader>ln", vim.lsp.buf.rename,          { desc = "Rename" })
  map("n", "<leader>lr", vim.lsp.buf.references,      { desc = "References" })
  map("n", "<leader>ls", vim.lsp.buf.signature_help,  { desc = "Signature Help" })
  map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Type Definition" })
  -- stylua: ignore end

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(false)
  end
end

-- List of servers to enable
local servers = {
  "angularls",
  "basedpyright",
  "bashls",
  "css_variables",
  "cssls",
  "cssmodules_ls",
  "dockerls",
  "emmet_language_server",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  "ts_ls",
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

  if name == "emmet_language_server" then
    local kinds = vim.lsp.protocol.CompletionItemKind
    kinds.Emmet = "󰅴 Emmet Abbreviation"
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
