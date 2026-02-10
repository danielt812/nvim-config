local snippets = require("mini.snippets")

snippets.setup({
  snippets = {
    snippets.gen_loader.from_file("~/.config/nvim/snippets/global.lua"),
    snippets.gen_loader.from_lang({
      lang_patterns = {
        lua = { "lua.json" },
        javascript = { "javascript.json" },
        typescript = { "typescript.json" },
        sh = { "shell.json" },
        zsh = { "shell.json" },
        bash = { "shell.json" },
        markdown = { "markdown.json" },
        dockerfile = { "docker_file.json" },
      },
    }),
  },
  mappings = {
    -- NOTE: mini.keymaps is handling snippet jump and expansion
    expand = "",
    jump_next = "",
    jump_prev = "",
    stop = "<Esc>",
  },
})

snippets.start_lsp_server()
