local completion = require("mini.completion")

-- Shared capabilities
local capabilities =
  vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), completion.get_lsp_capabilities(), {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  })

-- Shared on_attach
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, key_opts)
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

  if client.supports_method("textDocument/inlayHint") then vim.lsp.inlay_hint.enable(false) end
end

-- List of servers to enable
local servers = {
  "angularls",
  "autotools_ls",
  "basedpyright",
  "bashls",
  "css_variables",
  "cssls",
  "cssmodules_ls",
  "docker_language_server",
  "emmet_language_server",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "taplo",
  "tailwindcss",
  "ts_ls",
  "tsgo",
  "yamlls",
}

-- Register each server configuration under vim.lsp.configs
for _, server in ipairs(servers) do
  local ok, conf = pcall(require, "lsp." .. server)
  if not ok then
    vim.notify("Failed to load LSP config: lsp." .. server, vim.log.levels.WARN)
    conf = {}
  end

  if server == "emmet_language_server" then
    local kinds = vim.lsp.protocol.CompletionItemKind
    kinds.Emmet = "󰅴 Emmet Abbreviation"
  end

  vim.lsp.config[server] = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, conf or {})
end

-- Enable them all
vim.lsp.enable(servers)

local lsp_health = function() vim.cmd("checkhealth lsp") end
local lsp_log = function() vim.cmd("edit " .. vim.lsp.get_log_path()) end

vim.api.nvim_create_user_command("LspInfo", lsp_health, { desc = "Lsp checkhealth"})
vim.api.nvim_create_user_command("LspLog", lsp_log, { desc = "Lsp log" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("semantic_highlights", { clear = true }),
  desc = "Clear some semantic highlighting",
  callback = function()
    -- :h lsp-semantic-highlight
    -- Hide semantic highlights for functions
    vim.api.nvim_set_hl(0, "@lsp.type.variable", {})

    -- Hide all semantic highlights
    -- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    --   vim.api.nvim_set_hl(0, group, {})
    -- end
  end,
})
