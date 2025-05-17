local M = { "echasnovski/mini.diff" }

M.enabled = true

M.event = { "BufReadPost" }

M.opts = function()
  return {
    -- Options for how hunks are visualized
    view = {
      -- Visualization style. Possible values are 'sign' and 'number'.
      -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
      style = "sign",

      -- Signs used for hunks with 'sign' view
      signs = { add = "+", change = "~", delete = "-" },

      -- Priority of used visualization extmarks
      priority = 199,
    },

    -- Source(s) for how reference text is computed/updated/etc
    -- Uses content from Git index by default
    source = nil,

    -- Delays (in ms) defining asynchronous processes
    delay = {
      -- How much to wait before update following every text change
      text_change = 200,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = "gh",

      -- Reset hunks inside a visual/operator region
      reset = "gH",

      -- Hunk range textobject to be used inside operator
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = "gh",

      -- Go to hunk range in corresponding direction
      goto_first = "[H",
      goto_prev = "[h",
      goto_next = "]h",
      goto_last = "]H",
    },

    -- Various options
    options = {
      -- Diff algorithm. See `:h vim.diff()`.
      algorithm = "histogram",

      -- Whether to use "indent heuristic". See `:h vim.diff()`.
      indent_heuristic = true,

      -- The amount of second-stage diff to align lines (in Neovim>=0.9)
      linematch = 60,

      -- Whether to wrap around edges during hunk navigation
      wrap_goto = false,
    },
  }
end

M.config = function(_, opts)
  require("mini.diff").setup(opts)
  -- local minidiff_settings_group = vim.api.nvim_create_augroup("minidiff_settings_group", { clear = true })
  -- vim.api.nvim_create_autocmd("User", {
  --   group = minidiff_settings_group,
  --   pattern = "MiniDiffUpdated",
  --   desc = "Format Mini Diff summary string with colors for statusline",
  --   callback = function(data)
  --     local summary = vim.b[data.buf].minidiff_summary
  --     -- NOTE these are custom highlight groups that are not part of MiniNvim
  --     local symbols = {
  --       add = "%#MiniStatuslineDiffAdd# ",
  --       change = "%#MiniStatuslineDiffChange# ",
  --       delete = "%#MiniStatuslineDiffDelete# ",
  --     }
  --
  --     local t = {}
  --     if summary.add > 0 then
  --       table.insert(t, symbols.add .. summary.add)
  --     end
  --     if summary.change > 0 then
  --       table.insert(t, symbols.change .. summary.change)
  --     end
  --     if summary.delete > 0 then
  --       table.insert(t, symbols.delete .. summary.delete)
  --     end
  --
  --     -- Reset highlight after diff summary
  --     table.insert(t, "%*")
  --
  --     vim.b[data.buf].minidiff_summary_string = table.concat(t, " ")
  --   end,
  -- })
end

return M
