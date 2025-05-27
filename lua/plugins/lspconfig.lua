local lazydev = require("lazydev")
local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp = pcall(require, "blink.cmp")
if not ok then
  cmp = require("mini.completion")
end

capabilities = vim.tbl_deep_extend("force", capabilities, cmp.get_lsp_capabilities())

capabilities = vim.tbl_deep_extend("force", capabilities, {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
})

local on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs, key_opts)
    key_opts = key_opts or {}
    key_opts.silent = key_opts.silent ~= false
    key_opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, key_opts)
  end

  -- stylua: ignore start
  map("n", "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<cr>", { desc = "Show Hover" })
  map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help({border = 'rounded'})<cr>", { desc = "Signature Help" })
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Definition" })
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Declaration" })
  map("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code Action" })
  map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename Definition" })
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Implementation" })
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "References" })
  map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type Definition" })
  map("n", "g.", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format" })
  -- stylua: ignore end

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(false)
  end
end

lazydev.setup()

local servers = { "lua_ls" }

for _, server in pairs(servers) do
  local lsp_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local conf_opts = require("lsp_settings." .. server)

  if conf_opts ~= nil then
    lsp_opts = vim.tbl_deep_extend("force", conf_opts, lsp_opts)
  end

  require("lspconfig")[server].setup(lsp_opts)
end

local diagnostic_opts = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  -- virtual_text = true,
  virtual_lines = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    suffix = "",
  },
}

vim.diagnostic.config(diagnostic_opts)
