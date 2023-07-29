return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "b0o/SchemaStore.nvim" },
    { "folke/neodev.nvim" },
    { "ray-x/lsp_signature.nvim" },
  },
  opts = function()
    local signs = {
      { name = "DiagnosticSignError", text = " " },
      { name = "DiagnosticSignWarn", text = " " },
      { name = "DiagnosticSignHint", text = " " },
      { name = "DiagnosticSignInfo", text = " " },
    }
    return {
      -- disable virtual text
      virtual_text = false,
      -- show signs
      signs = {
        active = signs,
      },
      update_in_insert = true,
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
  end,
  config = function(_, opts)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local function lsp_keymaps(bufnr)
      local function key_opts(desc)
        return { desc = desc, noremap = true, silent = true }
      end

      local function map(key, cmd, desc)
        return vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd, desc)
      end

      map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", key_opts("Show Hover"))
      map("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", key_opts("Go to Declaration"))
      map("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", key_opts("Go to Definition"))
      map("gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", key_opts("Go to Type Definition"))
      map("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", key_opts("Go to Implementation"))
      map("gr", "<cmd>lua vim.lsp.buf.references()<CR>", key_opts("Go to References"))
      map("gl", "<cmd>lua vim.diagnostic.open_float()<CR>", key_opts("Open Float"))
      map("gR", "<cmd>lua vim.lsp.buf.rename()<CR>", key_opts("Rename Definition"))
      map("gA", "<cmd>lua vim.lsp.buf.code_action()<CR>", key_opts("Code Action"))
    end

    local lspconfig = require("lspconfig")
    local on_attach = function(client, bufnr)
      lsp_keymaps(bufnr)
      require("illuminate").on_attach(client)
    end

    require("lsp_signature").setup()
    require("neodev").setup()

    for _, server in pairs(require("servers")) do
      Opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      server = vim.split(server, "@")[1]

      local conf_opts = require("lsp_settings." .. server)

      Opts = vim.tbl_deep_extend("force", conf_opts, Opts)

      lspconfig[server].setup(Opts)
    end

    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config(opts)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end,
}
