local M = { "declancm/cinnamon.nvim" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {
    keymaps = {
      basic = false, -- Enable the basic keymaps
      extra = false, -- Enable the extra keymaps
    },
    -- The scrolling mode
    -- `cursor`: animate cursor and window scrolling for any movement
    -- `window`: animate window scrolling ONLY when the cursor moves out of view
    mode = "cursor",
    options = {
      callback = function() -- Post-movement callback
      end,
      delay = 5, -- Delay between each movement step (in ms)
      max_delta = {
        line = 150, -- Maximum delta for line movements
        column = 200, -- Maximum delta for column movements
      },
    },
  }
end

M.config = function(_, opts)
  require("cinnamon").setup(opts)

  local cinnamon = require("cinnamon")

  vim.keymap.set({ "n" }, "<C-U>", function()
    cinnamon.scroll("<C-U>zz")
  end)
  vim.keymap.set({ "n" }, "<C-D>", function()
    cinnamon.scroll("<C-D>zz")
  end)

  vim.keymap.set({ "n", "v" }, "<PageUp>", function()
    cinnamon.scroll("<PageUp>zz")
  end)

  vim.keymap.set({ "n", "v" }, "<PageDown>", function()
    cinnamon.scroll("<PageDown>zz")
  end)

  vim.keymap.set({ "n" }, "n", function()
    cinnamon.scroll("nzz")
  end)

  vim.keymap.set({ "n" }, "N", function()
    cinnamon.scroll("Nzz")
  end)
end

return M
