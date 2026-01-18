local treesitter = require("nvim-treesitter")

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local languages = {
  "bash",
  "c",
  "comment",
  "css",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "markdown",
  "query",
  "regex",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zsh",
}

treesitter.install(languages)

local filetypes = {}

for _, language in ipairs(languages) do
  for _, filetype in ipairs(vim.treesitter.language.get_filetypes(language)) do
    table.insert(filetypes, filetype)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
  desc = "Start treesitter",
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
