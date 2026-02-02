return {
  cmd = { "autotools-language-server" },
  filetypes = { "config", "automake", "make" },
  root_markers = { ".git" },
  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    -- Only attach if there's some eslint config file in the root directory.
    local root_dir = vim.fs.dirname(vim.fs.find({ "Makefile" }, { path = filename, upward = true })[1])
    if not root_dir then return nil end

    cb(root_dir)
  end,
}
