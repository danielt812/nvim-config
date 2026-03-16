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
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "http",
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
  "sql",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zsh",
}

-- Parsers bundled with plugins: not on nvim-treesitter repo, skip install/update
local bundled = { kulala_http = true }

-- Override TSUpdate to exclude bundled parsers (they're not in the official registry
-- so nvim-treesitter would warn "skipping unsupported language" for each one)
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.api.nvim_create_user_command("TSUpdate", function(args)
      local langs = args.fargs
      if #langs == 0 then
        langs = vim.tbl_filter(
          function(l) return not bundled[l] end,
          treesitter.get_installed()
        )
      end
      treesitter.update(langs, { summary = true })
    end, { nargs = "*", bar = true, desc = "Update installed treesitter parsers" })
  end,
})

local function isnt_installed(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end

local to_install = vim.tbl_filter(isnt_installed, languages)

if #to_install > 0 then treesitter.install(to_install) end

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}

for _, language in ipairs(languages) do
  for _, filetype in ipairs(vim.treesitter.language.get_filetypes(language)) do
    table.insert(filetypes, filetype)
  end
end

local function start_treesitter(args)
  local lang = vim.bo[args.buf].filetype

  if vim.treesitter.language.get_lang(lang) then
    vim.treesitter.start(args.buf)
    vim.bo[args.buf].syntax = "OFF"
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
  desc = "Auto start treesitter",
  callback = start_treesitter,
})
