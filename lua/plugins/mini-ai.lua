local M = { "echasnovski/mini.ai" }

M.enabled = true

M.dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" }

M.event = { "BufReadPost" }

M.opts = function()
  local spec_treesitter = require("mini.ai").gen_spec.treesitter
  return {
    -- Table with textobject id as fields, textobject specification as values.
    -- Also use this to disable builtin textobjects. See |MiniAi.config|.
    custom_textobjects = {
      f = spec_treesitter({
        a = "@function.outer",
        i = "@function.inner",
      }),
      o = spec_treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Main textobject prefixes
      around = "a",
      inside = "i",

      -- Next/last variants
      around_next = "an",
      inside_next = "in",
      around_last = "al",
      inside_last = "il",

      -- Move cursor to corresponding edge of `a` textobject
      goto_left = "g[",
      goto_right = "g]",
    },

    -- Number of lines within which textobject is searched
    n_lines = 50,

    -- How to search for object (first inside current line, then inside
    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
    -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
    search_method = "cover_or_next",

    -- Whether to disable showing non-error feedback
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.ai").setup(opts)
end

return M
