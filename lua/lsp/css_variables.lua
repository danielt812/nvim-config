return {
  cmd = { "css-variables-language-server", "--stdio" },
  filetypes = { "css", "less", "scss" },
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "package.json", ".git" })
    if root then cb(root) end
  end,
  settings = {
    cssVariables = {
      lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
      blacklistFolders = {
        "**/.cache",
        "**/.DS_Store",
        "**/.git",
        "**/.hg",
        "**/.next",
        "**/.svn",
        "**/bower_components",
        "**/CVS",
        "**/dist",
        "**/node_modules",
        "**/tests",
        "**/tmp",
      },
    },
  },
}
