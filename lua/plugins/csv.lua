local M = { "cameron-wags/rainbow_csv.nvim" }

M.enabled = true

M.ft = {
  "csv",
  "tsv",
  "csv_semicolon",
  "csv_whitespace",
  "csv_pipe",
  "rfc_csv",
  "rfc_semicolon",
}

M.config = true

M.cmd = {
  "RainbowDelim",
  "RainbowDelimSimple",
  "RainbowDelimQuoted",
  "RainbowMultiDelim",
}

return M
