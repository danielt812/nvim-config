local M = { "echasnovski/mini.nvim" }

M.enabled = true

M.event = { "BufReadPost" }

M.opts = function()
  return {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "<A-h>",
      right = "<A-l>",
      down = "<A-j>",
      up = "<A-k>",

      -- Move current line in Normal mode
      line_left = "<A-h>",
      line_right = "<A-l>",
      line_down = "<A-j>",
      line_up = "<A-k>",
    },

    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  }
end

M.config = function(_, opts)
  require("mini.move").setup(opts)
end

return M
