local M = { "neovim/nvim-lspconfig" }

M.enabled = true

M.dependencies = {
  { "SmitheshP/nvim-navbuddy" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "b0o/SchemaStore.nvim" },
  { "j-hui/fidget.nvim" },
}

M.event = { "BufReadPre", "BufNewFile" }

M.cmd = { "LspInfo", "LspInstall", "LspUninstall" }

M.keys = {
  { "<leader>lil", "<cmd>LspInfo<cr>", desc = "LSP " },
}

M.config = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = require("cmp_nvim_lsp").default_capabilities()

  local on_attach = function(client, bufnr)
    require("utils.lsp_utils").add_keymaps(bufnr)

    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false)
    end
  end

  local servers = require("servers")

  for _, server in pairs(servers) do
    local lsp_opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    local conf_opts = require("lsp_settings." .. server)

    if conf_opts == nil then
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
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    virtual_text = true,
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

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

return M
