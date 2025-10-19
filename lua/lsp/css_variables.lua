return {
  cmd = {
    "css-variables-language-server",
    "--stdio",
  },
  filetypes = {
    "css",
    "less",
    "scss",
  },
  root_markers = {
    ".git",
    "package.json",
  },
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
