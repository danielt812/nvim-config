return {
  default_config = {
    cmd = { "graphql-lsp", "server", "-m", "stream" },
    filetypes = { "graphql", "typescriptreact", "javascriptreact" },
    root_dir = function(fname)
      -- Try to find the nearest GraphQL config, or fallback to git root or cwd
      local root_files = {
        ".graphqlrc",
        ".graphqlrc.json",
        ".graphqlrc.yaml",
        ".graphqlrc.yml",
        ".graphqlrc.js",
        ".graphql.config.json",
        ".graphql.config.js",
      }

      -- Find upward from the current file
      local path = vim.fs.find(root_files, { upward = true, path = fname })[1]
      if path then
        return vim.fs.dirname(path)
      end

      -- fallback: look for a git repo root
      local git_root = vim.fs.find(".git", { upward = true, path = fname })[1]
      if git_root then
        return vim.fs.dirname(git_root)
      end

      -- fallback: current working directory
      return vim.fn.getcwd()
    end,
  },
}

