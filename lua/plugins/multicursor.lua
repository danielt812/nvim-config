local multicursor = require("multicursor-nvim")
multicursor.setup()

-- VM-like “match next/prev”
vim.keymap.set({ "n", "x" }, "<C-n>", function() multicursor.matchAddCursor(1) end)
vim.keymap.set({ "n", "x" }, "<C-p>", function() multicursor.matchAddCursor(-1) end)

-- Cursor navigation layer (your existing pattern is good)
multicursor.addKeymapLayer(function(layerSet)
  layerSet({ "n", "x" }, "<left>",  multicursor.prevCursor)
  layerSet({ "n", "x" }, "<right>", multicursor.nextCursor)

  -- VM-ish “remove cursor” (choose a key you like)
  layerSet({ "n", "x" }, "<C-d>", multicursor.deleteCursor)

  -- VM-ish escape behavior
  layerSet({ "n", "x" }, "<esc>", function()
    if multicursor.cursorsEnabled and multicursor.cursorsEnabled() then
      multicursor.clearCursors()
    else
      -- If the plugin doesn't expose cursorsEnabled(), just clear anyway:
      pcall(multicursor.clearCursors)
    end
  end)
end)
