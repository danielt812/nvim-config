---@brief
---
--- https://rust-analyzer.github.io/
---
--- Rust language server.

---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.root(fname, { "Cargo.toml", "rust-project.json" }) or vim.fs.root(fname, ".git"))
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },
      check = {
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = { enable = true },
      diagnostics = { experimental = { enable = true } },
      inlayHints = {
        bindingModeHints = { enable = false },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true, minLines = 25 },
        closureReturnTypeHints = { enable = "never" },
        lifetimeElisionHints = { enable = "never", useParameterNames = false },
        maxLength = 25,
        parameterHints = { enable = true },
        reborrowHints = { enable = "never" },
        renderColons = true,
        typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
      },
    },
  },
}
