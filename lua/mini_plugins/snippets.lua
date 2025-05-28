local snippets = require("mini.snippets")

snippets.setup({
  -- Array of snippets and loaders (see |MiniSnippets.config| for details).
  -- Nothing is defined by default. Add manually to have snippets to match.
  snippets = {
    snippets.gen_loader.from_file("~/.config/nvim/snippets/global.lua"),
    snippets.gen_loader.from_lang({
      lang_patterns = {
        lua = { "lua.json" },
      },
    }),
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Expand snippet at cursor position. Created globally in Insert mode.
    -- NOTE - mini.keymaps is handling snippet expansion via super tab/shift-tab
    expand = "",

    -- Interact with default `expand.insert` session.
    -- Created for the duration of active session(s)
    jump_next = "",
    jump_prev = "",
    stop = "<Esc>",
  },

  -- Functions describing snippet expansion. If `nil`, default values
  -- are `MiniSnippets.default_<field>()`.
  expand = {
    -- Resolve raw config snippets at context
    prepare = nil,
    -- Match resolved snippets at cursor position
    match = nil,
    -- Possibly choose among matched snippets
    select = nil,
    -- Insert selected snippet
    insert = nil,
  },
})

snippets.start_lsp_server({
  match = false, -- Let the completion engine handle matching
})
