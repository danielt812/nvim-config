return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { ".marksman.toml", ".git" })
    if root then cb(root) end
  end,
}
