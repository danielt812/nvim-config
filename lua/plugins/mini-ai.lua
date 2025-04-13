local M = { "echasnovski/mini.ai" }

M.enabled = true

M.dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" }

M.event = { "BufReadPost" }

M.opts = function()
  local ai = require("mini.ai")
  return {
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({ -- code block
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    },
  }
end

M.config = function(_, opts)
  require("mini.ai").setup(opts)
end

return M
