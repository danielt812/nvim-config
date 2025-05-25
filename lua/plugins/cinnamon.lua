local M = { "declancm/cinnamon.nvim" }

M.enabled = false

M.event = { "BufReadPre", "BufEnter" }

M.opts = function()
  return {
    keymaps = {
      basic = false,
      extra = false,
    },
    options = {
      mode = "window",
      callback = function()
        vim.notify("Cinnamon Scrolled")
      end,
    },
  }
end

M.config = function(_, opts)
  local cinnamon = require("cinnamon")

  cinnamon.setup(opts)

  -- Half-window movements:
  vim.keymap.set({ "n", "x" }, "<C-u>", function()
    cinnamon.scroll("<C-u>zz")
  end)
  vim.keymap.set({ "n", "x" }, "<C-d>", function()
    cinnamon.scroll("<C-d>zz")
  end)

  -- Page movements:
  vim.keymap.set({ "n", "x" }, "<C-b>", function()
    cinnamon.scroll("<C-b>zz")
  end)
  vim.keymap.set({ "n", "x" }, "<C-f>", function()
    cinnamon.scroll("<C-f>zz")
  end)
  vim.keymap.set({ "n", "x" }, "<PageUp>", function()
    cinnamon.scroll("<PageUp>zz")
  end)
  vim.keymap.set({ "n", "x" }, "<PageDown>", function()
    cinnamon.scroll("<PageDown>zz")
  end)
end

return M
