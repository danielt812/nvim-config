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
