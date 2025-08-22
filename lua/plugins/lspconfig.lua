local typescript_tools = require("typescript-tools")

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
  map("n", "K",          "<cmd>lua vim.lsp.buf.hover()<cr>",           { desc = "Show Hover" })
  map("n", "g.",         "<cmd>lua vim.lsp.buf.format()<cr>",          { desc = "Format" })
  map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",     { desc = "Code Action" })
  map("n", "<leader>lc", "<cmd>lua vim.lsp.buf.declaration()<cr>",     { desc = "Declaration" })
  map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>",      { desc = "Definition" })
  map("n", "<leader>le", "<cmd>lua vim.lsp.buf.references()<cr>",      { desc = "References" })
  map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>",          { desc = "Format" })
  map("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>",  { desc = "Implementation" })
  map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",          { desc = "Rename Definition" })
  map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>",  { desc = "Signature Help" })
  map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type Definition" })
  -- stylua: ignore end

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(false)
  end
end

typescript_tools.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = true,
    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = "insert_leave",
    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
    -- "remove_unused_imports"|"organize_imports") -- or string "all"
    -- to include all supported code actions
    -- specify commands exposed as code_actions
    expose_as_code_action = {},
    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
    -- not exists then standard path resolution strategy is applied
    tsserver_path = nil,
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    tsserver_plugins = {},
    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
    -- memory limit in megabytes or "auto"(basically no limit)
    tsserver_max_memory = "auto",
    -- described below
    tsserver_format_options = {},
    tsserver_file_preferences = {},
    -- locale of all tsserver messages, supported locales you can find here:
    -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
    tsserver_locale = "en",
    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
    complete_function_calls = false,
    include_completions_with_insert_text = true,
    -- CodeLens
    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
    code_lens = "off",
    -- by default code lenses are displayed on all referencable values and for some of you it can
    -- be too much this option reduce count of them by removing member references from lenses
    disable_member_code_lens = true,
    -- JSXCloseTag
    -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
    -- that maybe have a conflict if enable this feature. )
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    },
  },
})

local servers = {
  "angularls",
  "bashls",
  "cssls",
  "emmet_language_server",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "tailwindcss",
  -- "ts_ls",
  "yamlls",
}

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
    priority = 9999,
    severity = { min = "WARN", max = "ERROR" },
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
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
