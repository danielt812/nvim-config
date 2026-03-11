local multicursor = require("multicursor-nvim")

multicursor.setup()

-- VM-like “add cursor by line”
vim.keymap.set({ "n", "x" }, "<Down>", function() multicursor.lineAddCursor(1) end)
vim.keymap.set({ "n", "x" }, "<Up>", function() multicursor.lineAddCursor(-1) end)

-- VM-like “match next/prev”
vim.keymap.set({ "n", "x" }, "<C-p>", function() multicursor.matchAddCursor(-1) end)
vim.keymap.set({ "n", "x" }, "<C-n>", function() multicursor.matchAddCursor(1) end)

-- Cursor navigation layer (your existing pattern is good)
multicursor.addKeymapLayer(function(layerSet)
  layerSet({ "n", "x" }, "<left>", multicursor.prevCursor)
  layerSet({ "n", "x" }, "<right>", multicursor.nextCursor)

  -- VM-ish “remove cursor” (choose a key you like)
  layerSet({ "n", "x" }, "<C-d>", multicursor.deleteCursor)

  -- VM-ish escape behavior
  layerSet({ "n", "x" }, "<esc>", function()
    if multicursor.cursorsEnabled() then
      multicursor.clearCursors()
    end
  end)
end)

local gen_hl_groups = function()
  -- stylua: ignore start
  vim.api.nvim_set_hl(0, "MultiCursorCursor",       { link = "Search" })
  vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "IncSearch" })
  -- stylua: ignore end
end

gen_hl_groups() -- Call this now if colorscheme was already set
