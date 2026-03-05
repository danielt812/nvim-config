return {
  cmd = {
    "harper-ls",
    "--stdio",
  },
  filetypes = {
    "gitcommit",
    "markdown",
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local git_root = vim.fs.find(".git", { upward = true, path = fname })[1]
    if git_root then return on_dir(vim.fs.dirname(git_root)) end

    -- Fallback: cwd
    return on_dir(vim.fn.getcwd())
  end,
  single_file_support = true,
  settings = {
    ["harper-ls"] = {
      userDictPath = vim.fn.stdpath("config") .. "/spell/harper.txt",
    },
  },
}
