local completion = require("mini.completion")

local kind_priority = { Text = -1, Snippet = 99 }
local opts = { filtersort = "fuzzy", kind_priority = kind_priority }
local process_items = function(items, base)
  local processed = completion.default_process_items(items, base, opts)

  for _, item in ipairs(processed) do
    print(item.menu)
    if item.menu and item.menu:sub(-2) == " S" then
      item.menu = item.menu:sub(1, -3) -- strip trailing " S"
    end
  end

  return processed
end

completion.setup({
  lsp_completion = {
    source_func = "omnifunc",
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
