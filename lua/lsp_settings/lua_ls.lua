return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
        displayContext = "1",
      },
      format = {
        enable = false,
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
        workspaceEvent = "OnChange", -- "OnChange", "OnSave", "None"
      },
      hint = {
        enable = true,
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          "${3rd}/luv/library",
        },
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
