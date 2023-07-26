return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    { "hrsh7th/cmp-nvim-lsp" },
    { "williamboman/mason-lspconfig.nvim" }
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
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local function lsp_keymaps(bufnr)
      local function opts(desc)
        return { desc = desc, noremap = true, silent = true }
      end

      local function map(key, cmd, opts)
        return vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd, opts)
      end

      map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts("Show Hover"))
      map("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts("Go to Declaration"))
      map("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts("Go to Definition"))
      map("gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts("Go to Implementation"))
      map("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts("Go to references"))
      map("gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts("Open Float"))
      map("<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts("Format"))
    end

    local lspconfig = require("lspconfig")
    local on_attach = function(client, bufnr)
      lsp_keymaps(bufnr)
    end

    for _, server in pairs(require("servers")) do
      Opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      server = vim.split(server, "@")[1]

      local require_ok, conf_opts = pcall(require, "settings." .. server)
      if require_ok then
        Opts = vim.tbl_deep_extend("force", conf_opts, Opts)
      end

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
