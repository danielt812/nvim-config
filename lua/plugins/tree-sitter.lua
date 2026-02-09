local treesitter = require("nvim-treesitter")

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Add here more languages with which you want to use tree-sitter
-- To see available languages:
--   Execute `:lua require('nvim-treesitter').get_available()`
--   Or visit 'SUPPORTED_LANGUAGES.md' file at
--   https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local languages = {
  "angular",
  "bash",
  "c",
  "comment",
  "css",
  "diff",
  "git_config",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "python",
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

local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end

local to_install = vim.tbl_filter(isnt_installed, languages)

if #to_install > 0 then treesitter.install(to_install) end

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}

for _, language in ipairs(languages) do
  for _, filetype in ipairs(vim.treesitter.language.get_filetypes(language)) do
    table.insert(filetypes, filetype)
  end
end

if #filetypes > 0 then
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
    desc = "Auto start treesitter",
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end,
  })
end
