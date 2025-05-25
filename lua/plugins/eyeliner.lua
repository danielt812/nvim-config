local M = { "jinh0/eyeliner.nvim" }

M.dependencies = { "mawkler/demicolon.nvim" }

M.enabled = true

M.keys = { "f", "F", "t", "T" }

M.opts = function()
  return {
    highlight_on_key = true,
    dim = true,
    default_keymaps = false,
    disable_filetypes = { "ministarter" },
    disable_buftypes = { "nofile" },
  }
end

M.config = function(_, opts)
  local eyeliner = require("eyeliner")

  eyeliner.setup(opts)

  local jump = function(key)
    local forward = vim.list_contains({ "t", "f" }, key)
    return function()
      eyeliner.highlight({ forward = forward })
      return require("demicolon.jump").horizontal_jump(key)()
    end
  end

  local map = function(key)
    vim.keymap.set({ "n", "x", "o" }, key, jump(key), { expr = true })
  end

  local keys = { "f", "F", "t", "T" }

  for _, key in pairs(keys) do
    map(key)
  end
end

return M
