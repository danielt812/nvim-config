local conform = require("conform")

conform.setup({
  -- Set the log level. Use `:ConformInfo` to see the location of the log file.
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
  -- Conform will notify you when no formatters are available for the buffer
  notify_no_formatters = true,
})

-- stylua ----------------------------------------------------------------------
conform.formatters.stylua = {
  prepend_args = {
    "--config-path=stylua.toml",
  },
}

conform.formatters_by_ft.lua = { "stylua" }

-- Gofmt -----------------------------------------------------------------------
conform.formatters_by_ft.go = { "gofmt" }

-- Prettier --------------------------------------------------------------------
conform.formatters.prettierd = {
  prepend_args = {
    "--trailing-comma=es5",
    "--tab-width=2",
    "--single-quote=false",
    "--prose-wrap=preserve",
    "--print-width=120",
    "--single-attribute-per-line",
    -- "--config-precedence",
    -- "prefer-file",
  },
}

local prettier_filetypes = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "css",
  "scss",
  "html",
  "htmlangular",
  "json",
  "jsonc",
  "markdown",
  "toml",
}

for _, filetype in pairs(prettier_filetypes) do
  conform.formatters_by_ft[filetype] = { "prettierd", "prettier" }
end

-- shfmt -----------------------------------------------------------------------
conform.formatters.shfmt = {
  prepend_args = {
    "--indent",
    "2",
  },
}

local shfmt_filetypes = {
  "bash",
  "sh",
  "zsh",
}

for _, filetype in ipairs(shfmt_filetypes) do
  conform.formatters_by_ft[filetype] = { "shfmt" }
end

-- yamlfmt ---------------------------------------------------------------------
conform.formatters_by_ft.yaml = { "yamlfmt" }

local format = function()
  conform.format()
  vim.notify("Formatting " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end

vim.keymap.set("n", "g.", format, { desc = "Format" })

vim.api.nvim_create_user_command("ConformLog", function()
  local log_path = vim.fn.expand("~/.local/state/nvim/conform.log")
  vim.cmd("split " .. log_path)
end, { desc = "Open Conform log file" })

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
--   desc = "Format on save",
--   pattern = { "*.css", "*.go", "*.js", "*.json", "*.jsonc", "*.jsx", "*.lua", "*.py", "*.scss", "*.sh", "*.zsh" },
--   callback = format,
-- })
