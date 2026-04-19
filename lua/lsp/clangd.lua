---@brief
---
--- https://clangd.llvm.org/
---
--- C/C++/ObjC language server.

---@type vim.lsp.Config
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      vim.fs.root(fname, { "compile_commands.json", "compile_flags.txt", ".clangd" })
        or vim.fs.root(fname, { "CMakeLists.txt", "Makefile", "meson.build" })
        or vim.fs.root(fname, ".git")
    )
  end,
}
