local M = { "pmizio/typescript-tools.nvim" }

M.enabled = false

M.dependencies = {
  { "nvim-lua/plenary.nvim" },
  { "neovim/nvim-lspconfig" },
  { "saghen/blink.cmp" },
  -- { "hrsh7th/cmp-nvim-lsp" },
}

M.ft = { "typescript", "javascript", "javascriptreact", "typescriptreact" }

M.opts = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
  -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  local function lsp_keymaps(bufnr)
    local function map(mode, lhs, rhs, key_opts)
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      key_opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    map("n", "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<cr>", { desc = "Show Hover" })
    map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help({border = 'rounded'})<cr>", { desc = "[S]ignature Help" })
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "[D]efinition" })
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "[D]eclaration" })
    map("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code [A]ction" })
    map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "[R]ename Definition" })
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "[I]mplementation" })
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "[R]eferences" })
    map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "[T]ype Definition" })
    map("n", "<leader>laa", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code [A]Action" })
    map("n", "<leader>laf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "[F]ormat" })
    map("n", "<leader>laD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "[D]eclaration " })
    map("n", "<leader>laR", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "[R]ename Definition" })
    map("n", "<leader>lad", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "[D]efinition" })
    map("n", "<leader>lah", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Show [H]over" })
    map("n", "<leader>lai", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "[I]mplementation" })
    map("n", "<leader>lar", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "[R]eferences" })
    map("n", "<leader>lat", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Type [D]efinition" })
  end

  local on_attach = function(_, bufnr)
    lsp_keymaps(bufnr)
  end

  return {
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
  }
end

M.config = function(_, opts)
  require("typescript-tools").setup(opts)
end

return M
