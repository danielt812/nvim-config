local M = { "neovim/nvim-lspconfig" }

M.enabled = true

M.dependencies = {
  { "SmitheshP/nvim-navbuddy" },
  { "saghen/blink.cmp" },
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
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

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

    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show Hover" })
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to Definition" })
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to Declaration" })
    map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature Help" })
    map("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code Action" })
    map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename Definition" })
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to Implementation" })
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to References" })
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
