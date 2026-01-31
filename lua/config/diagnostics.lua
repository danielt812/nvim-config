vim.diagnostic.config({
  signs = {
    priority = 9999,
    severity = { min = "INFO", max = "ERROR" },
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  -- virtual_text = false,
  -- virtual_lines = {
  --   current_line = true,
  -- },
  -- update_in_insert = false,
  -- underline = true,
  -- severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    suffix = "",
  },
})

vim.keymap.set("n", "g?", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
