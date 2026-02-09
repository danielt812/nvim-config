local completion = require("mini.completion")

local process_items = function(items, base)
  local opts = {
    filtersort = "fuzzy",
    kind_priority = {
      Text = -1,
      Variable = -1,
      Snippet = 1,
      Emmet = 2,
      Keyword = 3,
      Function = 4,
    },
  }
  local processed = completion.default_process_items(items, base, opts)

  for _, item in ipairs(processed) do
    if item.detail == "Emmet Abbreviation" then item.kind = "Emmet" end
  end

  return processed
end

completion.setup({
  lsp_completion = {
    source_func = "completefunc",
    auto_setup = true,
    process_items = process_items,
    snippet_insert = nil,
  },
  fallback_action = "<C-n>",
  mappings = {
    force_twostep = "<C-Space>",
    force_fallback = "<A-Space>",
    scroll_up = "<PageUp>", -- <C-f> default
    scroll_down = "<PageDown>", -- <C-b> default
  },
  window = {
    info = { border = "rounded" },
    signature = { border = "rounded" },
  },
})
