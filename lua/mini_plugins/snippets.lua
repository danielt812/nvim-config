local snippets = require("mini.snippets")

local lang_patterns = {}

local lang_map = {
  { file = "lua.json", langs = { "lua" } },
  { file = "javascript.json", langs = { "javascript", "jsx" } },
  { file = "typescript.json", langs = { "typescript", "tsx" } },
  { file = "shell.json", langs = { "sh", "zsh", "bash" } },
  { file = "markdown.json", langs = { "markdown", "markdown_inline" } },
  { file = "docker_file.json", langs = { "dockerfile" } },
}

for _, entry in ipairs(lang_map) do
  for _, lang in ipairs(entry.langs) do
    lang_patterns[lang] = { entry.file }
  end
end

snippets.setup({
  snippets = {
    snippets.gen_loader.from_file("~/.config/nvim/snippets/global.lua"),
    snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
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
